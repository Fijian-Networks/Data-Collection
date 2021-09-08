library(kinship2)
library(tidyverse)
# tutorial code
data("sample.ped")
pedAll <- pedigree(id = sample.ped$id, dadid = sample.ped$father, momid = sample.ped$mother, sex = sample.ped$sex, famid = sample.ped$ped)

ped1basic <- pedAll["1"]
ped2basic <- pedAll["2"]

plot(ped1basic)

# attempt my shit
# need to create giant df, with parent details in row of each person node?
pedTest <- pedigree(id = householdMembers$`_id`, dadid = )

#####
# clean unused columns from housholdMembers DF
#####

personNodes <- householdMembers %>% select(id = '_id', firstName = first_name, lastName = last_name, sex = sex, age = age, householdID = household_id, livesInHousehold = lives_in_household, village = village, alive = is_alive, customaryMembership = customary_membership)
