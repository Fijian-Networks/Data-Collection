setwd("/Users/admin/Documents/SHAVER_NETWORK/cohesionAndConflict/Testing_assets/sqlite_dbs")
library("DBI")
library("uuid")
library("randomNames")
library("RSQLite")

# connect to db
db <- dbConnect(RSQLite::SQLite(), "sqlite.db")
#get household Id from list
generate.household_id <- function(index) {generate.household_id_list[index,]}
# get village name from list