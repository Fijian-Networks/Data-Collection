########################################################
# Attempt to tidy data and merge relations between person node, family and marriage edges
#
# References to marriage and family in person node??
########################################################

library(tidyverse)


# Household data convert to gramps
# Household Id, Name, village, Latitude, Longitude
householdCensus <- read_csv('csvs/household_census.csv')
tidy.households <- householdCensus %>% select(householdID = household_id, householdName = household_human_id, village = household_village, latitude = location_latitude, longitude = location_longitude)

write_csv(householdCensus, path = "households.csv")
write_csv(tidy.households, path = "tidyHouseholds.csv")

# Person nodes
# personID, firstName, lastName, sex, age, householdID, livesInHousehold, village, IsAlive, hasChildren, customaryMembership

householdMembers <- read_csv('csvs/household_member.csv')
tidy.persons <- householdMembers %>% select(personID = '_id', firstName = first_name, lastName = last_name, sex = sex, age = age, householdID = household_id, livesInHousehold = lives_in_household, village = village, isAlive = is_alive, hasChildren = has_children, customaryMembership = customary_membership)

write_csv(householdMembers, path = "personNodes.csv")
write_csv(tidy.persons, path = "tidyPersonNodes.csv")

# Families
# Marriage ID, Child ID
families_ODK <- read_csv('csvs/families.csv')
tidy.families <- families_ODK %>% select(marriageID = marriage_id, childID = child_id) %>% group_by(marriageID)

write_csv(families_ODK, path = "families.csv")
write_csv(tidy.families, path = "tidyFamilies.csv")

# Marriages
# Marriage ID, partner 1 ID, partner 2 ID, marital status
marriages_ODK <- read_csv('csvs/marriages.csv')
tidy.marriages <- marriages_ODK %>% select(marriage = "_id", partner1 = person_1, partner2 = person_2,  mStat = mstat)

write_csv(marriages_ODK, path = "marriages.csv")
write_csv(tidy.marriages, path = "tidyMarriages.csv")



