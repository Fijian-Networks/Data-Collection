library("devtools")
library("tidyverse")
library("AnthroTools")
library("rstudioapi")

##########
# Reformat csv from odk-x default to anthotools freelisting style
##########
setwd("/Users/admin/Documents/SHAVER_NETWORK/odkX/R_testing/freelisting")

# open CSV
FL <- selectFile()

# read in CSV
FL.csv.original <- arrange(as_tibble(read.csv(FL)))

# filter out default columns starting with X_, age, gender, location
# just leave ID and items
FL.csv.filtered <- select(FL.csv.original, -c(contains("X_"), "age", "gender"))

# change columns names item_01:item_10 to 1:10
newcolnames <- c("Subj", 1:10, "location")
colnames(FL.csv.filtered) <- newcolnames

# tidy the data into columns: id, order, item
FL.csv.tidy <- as.data.frame(gather(FL.csv.filtered, key = "Order", value = "CODE", '1':'10'))
# Convert order column to numeric
FL.csv.tidy$Order <-  as.numeric(as.character(FL.csv.tidy$Order))


######################
# AnthroTools part
# Salience Calculation
######################

FL.salience <- CalculateSalience(FL.csv.tidy)

# DealWithDoubles handles double ups in single id's choices, in case they list the same thing twice
FL.salience.byCode <- SalienceByCode(FL.salience, dealWithDoubles = "MAX")

# Grouping of location for salience
FL.salience.grouping <- CalculateSalience(FL.csv.tidy, GROUPING = 'location')
FL.salience.villageGroup <-SalienceByCode(FL.salience.grouping, dealWithDoubles = "MAX", GROUPING= "location")


###########
# Done!!! #
###########


#############################
#
# testing from js script csv
#
#############################

freelistTest <- selectFile()
unitCsv <- arrange(as_tibble(read.csv(freelistTest)))
colnames(unitCsv) <- newcolnames
tidyUnitCsv <- as.data.frame(gather(unitCsv, key = "Order", value = "CODE", '1':'10'))

tidyUnitCsv$Order <-  as.numeric(as.character(tidyUnitCsv$Order))

# Calc Salience
testFL <-CalculateSalience(tidyUnitCsv)

# DealWithDoubles handles double ups in single id's choices, in case they list the same thing twice
testFL.S <- SalienceByCode(testFL, dealWithDoubles = "MAX")

###############