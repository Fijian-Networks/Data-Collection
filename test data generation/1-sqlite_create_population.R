setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library("DBI")
library("uuid")
library("randomNames")
library("RSQLite")

#############################################
# Initialisation step
#############################################
# connect to db
db <- dbConnect(RSQLite::SQLite(), "sqlite.db")
# get list of all household IDs
generate.household_id_list <- dbGetQuery(db, "SELECT household_id FROM household_census")
# get list of household village from household_census db and select by index same as household_id
generate.household_village_list <- dbGetQuery(db, "SELECT household_village FROM household_census")
#############################################
# End initialisation step
#############################################




#get household Id from list
generate.household_id <- function(index) {generate.household_id_list[index,]}
# get village name from list
generate.village_from_household <- function(index) {generate.household_village_list[index,]}
# generate uuid
generate.uuid <- function() {paste("uuid:",uuid::UUIDgenerate(), sep = "")};
# generate names
generate.last_name <- function() {randomNames::randomNames(n=1,ethnicity = 2, which.names = "last")};
generate.first_name <- function(sex) {randomNames::randomNames(n=1, ethnicity=2, which.names = "first", gender = sex)};
generate.full_name <- function() {paste(tmp.first_name, tmp.last_name, sep = "_")};
# generate age and sex
generate.age <- function(){sample(60, 1) + 16} #rng, range 16 - 76
generate.sex <- function(sex){if (sex =="m") return("male") else if(sex == "f") return("female")}



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

generate.all <- function() {
  i <- 1
  while(i <= nrow(generate.household_id_list)){
    generate.full_household(i)
    i <- i + 1
  }
}


#############################################
# Generation step
#############################################
# This block will populate the linked sqlite db containing any number of household entries
# with random names (1 last name per household), random ratio of sex in each household,
# random age, ect...
##########################################################################################
# global db list of household_ids and villages
generate.household_id_list <- dbGetQuery(db, "SELECT household_id FROM household_census")
generate.household_village_list <- dbGetQuery(db, "SELECT household_village FROM household_census")

generate.all()
################