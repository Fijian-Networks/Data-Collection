setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library("DBI")
library("uuid")
library("randomNames")
library("RSQLite")
library("tidyverse")


#############################################
# Initialisation step
#############################################
# connect to db
db <- dbConnect(RSQLite::SQLite(), "sqlite.db")
# get all fields from social network table in main database
field_list <- as.list(dbListFields(db, "social_network"))
# get list of all household IDs, saved in array, accessed by index
household_id_list <- dbGetQuery(db, "SELECT household_id FROM household_census")

# goto end of file for final generation call
############################################
# End initialisation step
#############################################
# BEGIN FUNCTION DECLARATION
#############################################

generate.household_member_list <-  function(household_index){
  query <- paste('SELECT "_id", "name", "age", "sex", "village", "household_id" FROM household_member WHERE "household_id" = "', household_id_list[household_index,], '" ORDER BY "age" DESC, "sex" DESC', sep='')
  household_member_list<- dbGetQuery(db, query)
  household_member_list <- generate.religion_for_household(household_member_list)
  
  return(household_member_list)
}

generate.religion_for_household <- function(member_list){
  member_list$religion ="" #create or clear field
  religions <- list("methodist", "catholic", "anglican") # create list of possible religions
  member_list$religion = toString(sample(religions,1))
  return(member_list)
}

# define SQLite query to filter household_members by household_id & lives_in_household == "yes", and order descending by age and sex
# This is pasted together so that we can use variables created in this script. In this case, household_id from household_id_list[]
# This will be iterated upon once we start creating a whole villages worth of social network data
# A religion is assigned to a household in this step

# lives in household not used for testing

###########################################################
# lists for fields in SNA forms
###########################################################


# generate uuid
generate.uuid <- function() {return(paste("uuid:",uuid::UUIDgenerate(use.time = TRUE), sep = ""))}

#!#!#!#!#!#!#!#!#!##!#!#!#!#!#!#!#!#!##!#!#!#!#!#!#!#!#!##!#!#!#!#!#!#!#!#!#! 
# create an empty table with all fields from database as Columns and == NA
#!#!#!#!#!#!#!#!#!##!#!#!#!#!#!#!#!#!##!#!#!#!#!#!#!#!#!##!#!#!#!#!#!#!#!#!#! 
generate.participant_response.empty <- function(){
  empty_table <- as_tibble(dbListFields(db, "social_network")) %>% pivot_wider(names_from = "value")
  empty_table <- empty_table[0,] # remove all data from table
  return(empty_table)
}

# create metadata database needs to INSERT:
# param: tibble containing all database field names
# returns: tibble with metadata added
generate.metadata <- function(.data) {
  return(.data[1,] %>% mutate(`_savepoint_timestamp` = "2021-05-16T23:50:09.135000000", `_sync_state` = "new_row", `_default_access` = "FULL", `_form_id` = "social_network", `_row_owner` = "anonymous", `_savepoint_creator` = "anonymous", `_locale` = "en_NZ", `_id` = generate.uuid()))
}

# input: empty table, sex ("m" or "f")
generate.participant_response.info <- function(.data, sex, household_index) {
  ## generate household members list and filter out head and spouse
  household_member_list <- generate.household_member_list(household_index)
  household_head_and_spouse <- household_member_list[match(unique(household_member_list$sex),household_member_list$sex),]
  # sex logic
  if(sex == "m"){i <- 1} else if(sex =="f") {i <- 2} else {print("type m or f")}
  participant.info <-  as_tibble(household_head_and_spouse[i,]) %>% select(-c(age, household_id)) # head and spouse needed...
  # merge head_of_Household using fields as columns
  # rename columns to be same as field names
  # .data[1,] is the empty table, assigning to row one
  participant.info.table <- .data[1,] %>% mutate(participant_uuid = participant.info$`_id`,participant_fullname = participant.info$name, participant_sex = participant.info$sex, participant_location = participant.info$village, participant_religion_upbringing = participant.info$religion) 
  return(participant.info.table)
}

###########################################################
# Peer generation
###########################################################
# select 3-5 close friends with whom the participant is most likely to rely on,
# select 1-3 outliers
# create the table to draw from

generate.potential_friends <-  function(household_index) {
  get_friends_query <- query <- paste('SELECT "_id", "name", "age", "sex", "village", "household_id" FROM household_member WHERE "age" > 20 AND "household_id" != "', household_id_list[household_index,], '" ORDER BY "age" DESC, "sex" DESC', sep='')
  return(as_tibble(dbGetQuery(db, query)))
}

###########################################################
# answer generation for multiple questions.
# for all list based questions: 1 = items, 4 = food, cqm1 = task(labour), cqm2 = food(funeral/weddings), cqf1 = task(household)
# input: friend_table, question code (refer to https://github.com/kerianVaraine/cohesionAndConflict/blob/master/docs/sna_questions.md)
###########################################################

generate.list_based_questions <- function (friend_table, q) {
  if(q =="cq1"){
    # household items
    item_list <- c("pots", "bowls", "chairs", "cutlery", "sugar", "pillows", "mattress", "computer", "batteries", "blankets")
  } else if(q == "cq4"){
    # food
    item_list <- c("taro", "meat", "fish", "cassava", "fruit", "shellfish", "grains", "special treat", "bread", "potatoes")
  } else if(q == "cqm1"){
    # labour Male
    item_list <- c("planting", "roof raising", "gathering materials", "transportmaterials", "repairs")
  } else if(q == "cqm2") {
    # food funeral/wedding
    item_list <- c("kava", "pigs", "cow", "asparagus rolls", "taro", "fruit", "fish", "shellfish")
  } else if(q == "cqf1") {
    # tasks Female
    item_list <- c("cleaning", "laundry", "water", "cooking", "shifting", "childcare", "dishes")
  } else {
    print("enter question code to generate answers")
    return()
  }
  
  questions <- as_tibble(generate.participant_response.empty() %>% select(starts_with("{{q}}"))) # create empty tibble of all questions  
  # random no of samples, from 1 - 5
  number_of_responses <- sample(4,1, prob = c(0.2,0.3,0.3,0.2)) +1
  
  i = 1
  while(i <= number_of_responses){
    person <- friend_table[sample(nrow(friend_table), 1, prob = friends.probablity),]   # get randomly chosen friends details
    item <- item_list[sample(length(item_list), 1)]  # randomly select item from list
    
    # populates 1 set of answers, use of dply variables here {i}
    questions <- questions[1,] %>% mutate( "{q}_{i}_name" := person$name , "{q}_{i}_item" := item, "{q}_{i}_uuid" := person$`_id`)
    i <- i+1
  }
  
  return(questions)
}

#########################################
# CQ_2 - small amounts of money 
# cq_3 - larger amounts of money
# input:: q == question number (2 or 3)
# uuid, name, Amount
# probability skewed towards only 1 or 2 answers

generate.cq2_and_3 <- function (friend_table, q) {
  # amount of money from question parameter.
  if(q == 2){
    amount_max <- 20
    amount_min <- 0
  } else if(q==3){
    amount_max <- 100
    amount_min <- 20
  }
  
  questions <- as_tibble(generate.participant_response.empty() %>% select(starts_with("cq{{q}}"))) # create empty tibble of all questions  
  number_of_responses <- sample(4,1, prob = c(0.5,0.3,0.1,0.1)) + 1
  
  i = 1
  while(i <= number_of_responses){
    person <- friend_table[sample(nrow(friend_table), 1, prob = friends.probablity),]   # get randomly chosen friends details
    amount <- sample(amount_max,1) + amount_min
    questions <- questions[1,] %>% mutate( "cq{q}_{i}_name" := person$name , "cq{q}_{i}_amount" := amount, "cq{q}_{i}_uuid" := person$`_id`)
    i <- i+1
  }
  
  return(questions)
}

############################
# cqf_2, sn1, sn2, sn3, sn4 
# these only require uuid and name
# param is question prefix; cqf_2, snq1, snq2, snq3, snq4 

generate.general_name_id <- function (friend_table, q) {
  questions <- as_tibble(generate.participant_response.empty() %>% select(starts_with("{{q}}"))) # create empty tibble of all questions  
  number_of_responses <- sample(4,1, prob = c(0.5,0.3,0.1,0.1)) + 1
  i = 1
  while(i <= number_of_responses){
    person <- friend_table[sample(nrow(friend_table), 1, prob = friends.probablity),]   # get randomly chosen friends details
    questions <- questions[1,] %>% mutate( "{q}_{i}_name" := person$name , "{q}_{i}_uuid" := person$`_id`)
    i <- i+1
  }
  
  return(questions)
}

# function to generate all responses for single person, including male female logic.
generate.person_responses <- function (household_index, sex) {
  # init values
  response_table <- generate.participant_response.empty() %>% generate.participant_response.info(toString(toString(sex)),household_index) %>% generate.metadata() #generate participant
  q.friends <- generate.potential_friends(household_index) # collect all persons not living in household
  no_close.friends <- sample(3,1) + 2   # random number of close friends
  no_outlier.friends <- sample(3,1) + 1 # random number of outliers
  total_no.friends <- no_close.friends + no_outlier.friends # total number of friends for iteration
  table.friends <- q.friends[sample(nrow(q.friends), total_no.friends),] # select random persons as friends
  friends.probablity <<- c(rep(1,no_close.friends), rep(0.3,no_outlier.friends)) # set probability for closer friends, GLOBAL VARIABLE
  
  # cq1-4 
  cq1 <- generate.list_based_questions(table.friends, "cq1")
  cq2 <- generate.cq2_and_3(table.friends,2)
  cq3 <- generate.cq2_and_3(table.friends,3)
  cq4 <- generate.list_based_questions(table.friends, "cq4")
  
  # male or female questions, and join onto response_table.sex
  if(sex == "m"){
    cqm1 <- generate.list_based_questions(table.friends, "cqm1")
    cqm2 <- generate.list_based_questions(table.friends, "cqm2")
    
    response_table.sex <- response_table %>% replace_na(cqm1) %>% replace_na(cqm2)
  } else if(sex == "f") {
    cqf1 <- generate.list_based_questions(table.friends, "cqf1")
    cqf2 <- generate.general_name_id(table.friends, "cqf2")
    
    response_table.sex <- response_table %>% replace_na(cqf1) %>% replace_na(cqf2)
  } else{
    print("no sex assigned to entry")
  }
  
  #snq1-4
  qsnq1 <- generate.general_name_id(table.friends, "snq1")
  qsnq2 <- generate.general_name_id(table.friends, "snq2")
  qsnq3 <- generate.general_name_id(table.friends, "snq3")
  qsnq4 <- generate.general_name_id(table.friends, "snq4")
  
  # bring all responses into table...
  # This is gonna be ugly.
  
  output <- response_table.sex %>% replace_na(cq1) %>% replace_na(cq2) %>% replace_na(cq3) %>% replace_na(cq4) %>% replace_na(qsnq1) %>% replace_na(qsnq2) %>% replace_na(qsnq3) %>% replace_na(qsnq4)
  
  return(output)
}

# Iterate over all households in household_id_list
generate.all_households <- function(){
  household_id_list <- dbGetQuery(db, "SELECT household_id FROM household_census")
  responses <- generate.participant_response.empty()
  i <- 1
  r <- 1
  while(i<= nrow(household_id_list)){
    household_member_list <- generate.household_member_list(i)
    #extract oldest male and female from list
    household_member_list.head_and_spouse <- household_member_list[match(unique(household_member_list$sex),household_member_list$sex),]
    m_response <- generate.person_responses(i,"m")
    f_response <- generate.person_responses(i,"f")
    responses[r,] <- m_response
    responses[r+1,] <- f_response
    i <- i + 1
    r <- r+2
  }
  return(responses)  
}
###########################
# END OF FUNCTION DEFITIONS
#!#!#!#!#!#!#!#!#!##!#!#!#!#!#!#!#!#!##!#!#!#!#!#!#!#!#!##!#!#!#!#!#!#!#!#!##!#!#!##!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!
# Generate all responses for all households:
t <- generate.all_households()
# then insert into DB with dbAppendTable()
dbAppendTable(db, "social_network", t)
#!#!#!#!#!#!#!#!#!##!#!#!#!#!#!#!#!#!##!#!#!#!#!#!#!#!#!##!#!#!#!#!#!#!#!#!##!#!#!##!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!

#TODO: CLEAN THE FUCK UP [mm.... pretty close, but not quite. It is good enough for this right now however]