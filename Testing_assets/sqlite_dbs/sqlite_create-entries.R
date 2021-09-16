setwd("/Users/admin/Documents/SHAVER_NETWORK/cohesionAndConflict/Testing_assets/sqlite_dbs")
library("DBI")
library("uuid")
library("randomNames")
library("RSQLite")

# RSQLite
# connect to db
db <- dbConnect(RSQLite::SQLite(), "sqlite.db")

# Testing sqlite database entry method
# create one new entry to household_member, will need to concatenate into SQLite string for loops
#  
#  dbExecute(db, 'INSERT INTO household_member ("_id", "_savepoint_timestamp", "_sync_state", "first_name", "last_name") VALUES ("uuid:" || hex(randomblob(16)), "2021-05-16T23:50:09.135000000", "new_row", "first", "last")')

##############################################
# generate many new household_member entries #
##############################################

# functions and needed info
# get household_id list from db, then function to iterate over list for multiple houses
generate.household_id_list <- dbGetQuery(db, "SELECT household_id FROM household_census")

generate.household_id <- function(index) {generate.household_id_list[index,]}
# get list of household village from household_census db and select by index same as household_id
generate.household_village_list <- dbGetQuery(db, "SELECT household_village FROM household_census")
generate.village_from_household <- function(index) {generate.household_village_list[index,]}

# generate uuid
generate.uuid <- function() {paste("uuid:",uuid::UUIDgenerate(), sep = "")};
# generate names
generate.last_name <- function() {randomNames::randomNames(n=1,ethnicity = 2, which.names = "last")};
generate.first_name <- function(sex) {randomNames::randomNames(n=1, ethnicity=2, which.names = "first", gender = sex)};
generate.full_name <- function() {paste(tmp.first_name, tmp.last_name, sep = "_")};
# generate other fields
generate.age <- function(){sample(60, 1) + 16} #rng, range 16 - 76
generate.sex <- function(sex){if (sex =="m") return("male") else if(sex == "f") return("female")}


###################################
# Random person node fields       #
###################################
#these are done per household
tmp.household_id <- toString(generate.household_id(1)) # takes index from list of households
tmp.village <- toString(generate.village_from_household(1)) #takes index same as households
tmp.last_name <- generate.last_name();
tmp._savepoint_timestamp <- "2021-05-20T00:18:11.526000000"
tmp._sync_state <- "new_row"

# these will be done each human node
tmp.uuid <- generate.uuid()
tmp.sex <- generate.sex("m") # need at least 2 of each!
tmp.first_name <- generate.first_name(tmp.sex);
tmp.name <- generate.full_name()
tmp.age <- generate.age()

# create list for sqlite query using ? placeholders
tmp.list <- list(tmp.uuid, tmp.household_id, tmp.first_name, tmp.last_name, tmp.name, tmp.sex, tmp.village)

# write to db as human node into household_member table
dbExecute(db, 'INSERT INTO household_member ("_id", "household_id", "first_name", "last_name", "name", "sex", "village", "_savepoint_timestamp", "_sync_state") VALUES (?, ?, ?, ?, ?, ?, ?, "2021-05-16T23:50:09.135000000", "new_row")', tmp.list)
#####################################################################
# the above needs to be easy to iterate with parameters on the fly  #
# can it be turned into a function easily?                          #
#                                                                   #
# a function which creates a human from household choice and sex,   #
# doesn't output anything, but creates new entries into db          #
#                                                                   #
# Done! for one person at a time at least...                        #
# Need to iterate, give number of persons to generate,              #
# assign random sex but have at least 2 of each per household       #
# Use generate.person in larger function to generate.household      #
#####################################################################

# done once per household
generate.household <- function (household_list_select) {
  household_id <- toString(generate.household_id(household_list_select))
  village <- toString(generate.village_from_household(household_list_select)) 
  last_name <- generate.last_name();
  # create list for sqlite query using ? placeholders
  household_list <- list(household_id, village, last_name)
  return(household_list)
}

generate.person <- function(sex) {
  # these will be done each human node
  uuid <- generate.uuid()
  sex <- generate.sex(sex)
  first_name <- generate.first_name(sex);
  age <- generate.age()
  # create list for sqlite query using ? placeholders
  person_list <- list(uuid, first_name, sex, age)
  return(person_list)  
}

# takes list of fields from generate.household & generate.person
#   tmp.list <- list(tmp.uuid, tmp.household_id, tmp.first_name, tmp.last_name, tmp.name, tmp.sex, tmp.village, tmp.age)

# household_list contains (household_id, village, last_name)
# person_list contains (_id, first_name, sex, age)
# outputs list containing (household_id, village, last_name, _id, first_name, sex, age, name)

generate.full_person_list <- function (household_list, person_list) {
  # create full name from index of last and first name in household_list and person_list
  name <- paste(person_list[2],household_list[3],  sep = "_")
  # create list for sqlite query using ? placeholders
  full_person_list <- c(household_list, person_list, name)
  return(full_person_list)
}

# takes lists output from generate.full_person_list and feeds it to the "?" fields in INSERT SQL cmd.
push_to_db <- function(full_person_list) {
  dbExecute(db, 'INSERT INTO household_member ("household_id", "village", "last_name", "_id",  "first_name", "sex", "age", "name", "_savepoint_timestamp", "_sync_state", "_default_access", "_form_id", "_row_owner", "_savepoint_creator", "_locale") VALUES (?, ?, ?, ?, ?, ?, ?, ?, "2021-05-16T23:50:09.135000000", "new_row", "FULL", "household_member", "anonymous", "anonymous", "en_NZ")', full_person_list)
}


## testing generation functions- Works good so far
t <- generate.household(1)  # this will be done per household in list
b <- generate.person("m")   # this will be done x times for each sex in household
f <- generate.full_person_list(t,b) # done for every person to add
push_to_db(f) #done for every person to add

#################################################
# Populate one household                        #
# Where 2-4 people of each gender is generated  #
#################################################

#1 household, multiple persons, 2-5 of each sex (sample(3) + 2) therefore 4-10 people

generate.each_sex_per_household <-  function(no_of_sex, sex, household_list) {
  i <- 0
  while (i < no_of_sex) {
    b <- generate.person(sex)
    f <- generate.full_person_list(household_list,b)
    push_to_db(f)
    i <- i + 1
  }  
}

generate.full_household <- function (household_index){
  t <- generate.household(household_index)
  set.seed(sample(100,1))
  generate.each_sex_per_household(ceiling(runif(1,2,5)), "m", t)
  set.seed(sample(100,1))
  generate.each_sex_per_household(ceiling(runif(1,2,5)), "f", t)
}


## quick rand check

for(i in seq(1:10)) {
  print(ceiling(runif(1,2,5)))
}

###############################################################
# the magic function                                          #
# param:: index of household from generate.household_id_list  #
#
generate.full_household(2)                                    #
###############################################################

# now, iterate through household list and create all households at once!
generate.all <- function() {
  i <- 1
  while(i <= nrow(generate.household_id_list)){
    generate.full_household(i)
    i <- i + 1
  }
}


# This function will populate any sqlite db containing any number of household entries
# with random names (1 last name per household), random ratio of sex in each household,
# random age, ect...
##########################################################################################
# global db list of household_ids and villages
generate.household_id_list <- dbGetQuery(db, "SELECT household_id FROM household_census")
generate.household_village_list <- dbGetQuery(db, "SELECT household_village FROM household_census")

generate.all()
################