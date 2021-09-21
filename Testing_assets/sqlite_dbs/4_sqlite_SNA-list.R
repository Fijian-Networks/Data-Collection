setwd("/Users/admin/Documents/SHAVER_NETWORK/cohesionAndConflict/Testing_assets/sqlite_dbs")
library("DBI")
library("uuid")
library("randomNames")
library("RSQLite")

####
# connect to db
db <- dbConnect(RSQLite::SQLite(), "TEST_sqlite.db")
# get list of all household IDs, saved in array, accessed by index
household_id_list <- dbGetQuery(db, "SELECT household_id FROM household_census")

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
query <- paste('SELECT "_id", "name", "age", "sex", "village", "household_id" FROM household_member WHERE "lives_in_household" = "yes" AND "household_id" = "', household_id_list[1,], '" ORDER BY "age" DESC, "sex" DESC',sep='')
household_member_list<- dbGetQuery(db, query)
household_member_list <- generate.religion_for_household(household_member_list)

# Select oldest male and female from a household, to act as head and spouse for testing purposes
# this will be iterated upon for final generation
head_of_household <- household_member_list[1,]
head_of_household_spouse <- household_member_list[2,]


###########################################################
# Peer generation
###########################################################
# select 3-8 close friends with whom the participant is most likely to rely on,
# select 1-3 outliers
# create the list to draw from

# For selection of person to create edge to, Query be like:
# SELECT "name", "_id" FROM household_member WHERE "lives_in_household" = "yes" AND "household_id" != "', household_id_list[1], AND "age" > 20'
# Thus selecting anyone from anywhere that is NOT in their household and older than 20

get_friends_query <- query <- paste('SELECT "_id", "name", "age", "sex", "village", "household_id" FROM household_member WHERE "age" > 20 AND "household_id" != "', household_id_list[1,], '" ORDER BY "age" DESC, "sex" DESC', sep='')
q.friends <- dbGetQuery(db, query)
# TODO: from q.friends, randomly select 3-6 'close friends', then add a couple outliers

###########################################################
# lists for fields in SNA forms
###########################################################
q.sna.participant_info_list <- function(participant_info) {
  # participant_info = _id, name, age, sex, location, household_id, religion
  # bend participant info into these fields == "participant_uuid", "participant_fullname", "participant_age", "participant_sex", "participant_location", "participant_religion_upbringing"
return(list(participant_info$`_id`, participant_info$name, participant_info$age, participant_info$sex, participant_info$village, participant_info$religion))
}
tmp <- q.sna.participant_info_list(head_of_household)


# sqlite cmd:  'INSERT INTO social_network("participant_uuid", "participant_fullname", "participant_age", participant_sex", "participant_location", "participant_religion_upbringing") VALUES (?, ?, ?, ?, ? )', LIST HERE)''
# All this information will need to be INSERT-ed into "social_network" Table.


