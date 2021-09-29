########################################################
# tidy data in person node, family and marriage edges
#
########################################################

library(tidyverse)

# TODO: make csv directory a variable

# Household data convert to gramps
# Household Id, Name, village, Latitude, Longitude
householdCensus_ODK <- read_csv('raw_csv/household_census.csv')
tidy.households <- householdCensus_ODK %>% select(householdID = household_id, householdName = household_human_id, village = household_village, latitude = location_latitude, longitude = location_longitude, mataqali = mataqali, yavusa = yavusa, tokatoka = tokatoka, customary_membership_notes = customary_membership)

write_csv(tidy.households, path = "tidy_csv/tidyHouseholds.csv")

# Person nodes
# personID, firstName, lastName, sex, age, householdID, livesInHousehold, village, IsAlive, hasChildren

householdMembers_ODK <- read_csv('raw_csv/household_member.csv')
tidy.persons <- householdMembers_ODK %>% select(personID = '_id', firstName = first_name, lastName = last_name, sex = sex, age = age, householdID = household_id, livesInHousehold = lives_in_household, village = village, isAlive = is_alive, hasChildren = has_children)

write_csv(tidy.persons, path = "tidy_csv/tidyPersonNodes.csv")


# Marriages
# Marriage ID, partner 1 ID, partner 2 ID, marital status
marriages_ODK <- read_csv('raw_csv/marriages.csv')
tidy.marriages <- marriages_ODK %>% select(marriage = "_id", partner1 = person_1, partner2 = person_2,  mStat = mstat)

write_csv(tidy.marriages, path = "tidy_csv/tidyMarriages.csv")


# Families
# Connection between Marriage and Offspring, one entry per offspring of marriage
# Marriage ID, Child ID
tidy.families <- families_ODK %>% select(marriageID = marriage_id, childID = child_id) %>% group_by(marriageID)

write_csv(tidy.families, path = "tidy_csv/tidyFamilies.csv")



