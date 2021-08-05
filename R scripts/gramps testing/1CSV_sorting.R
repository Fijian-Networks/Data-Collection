library(tidyverse)
# GRAMPS EXPECTS THIS FORMAT FOR CSV IMPORT ::
#
# Places
# Place, Title, Name, Type, Latitude, Longitude, Code, Enclosed_by, Date
# 
# Individuals
# Person, Lastname, Firstname, Callname, Suffix, Prefix, Title, Gender, Birthdate, Birthplace (or Birthplaceid), Birthsource, Baptismdate, Baptismplace (or Baptismplaceid), Baptismsource, Deathdate, Deathplace (or Deathplaceid), Deathsource, Burialdate, Burialplace (or Burialplaceid), Burialsource, Note
# 
# Marriages
# Marriage, Husband, Wife, Date, Place (or Placeid), Source, Note
# 
# Families
# Family, Child


# Household data convert to gramps
# Place, Title, Name, Type, Latitude, Longitude, Code, Enclosed_by, Date
householdCensus <- read_csv('csvs/household_census.csv')
places <- householdCensus %>% select(grampsID = household_id, name = household_human_id,type = household_village, latitude = location_latitude, longitude = location_longitude)
write_csv(places, path = "places.csv")

## Individuals
# Person, Lastname, Firstname, Callname, Suffix, Prefix, Title, Gender, Birthdate, Birthplace (or Birthplaceid), 
# Birthsource, Baptismdate, Baptismplace (or Baptismplaceid), Baptismsource, Deathdate, Deathplace (or Deathplaceid),
# Deathsource, Burialdate, Burialplace (or Burialplaceid), Burialsource, Note
householdMembers <- read_csv('csvs/household_member.csv')
people <- householdMembers %>% select(grampsID = "_id", firstname = first_name, surname = last_name, gender = sex, residenceplace_id = household_id)
write_csv(people, path = "people.csv")

# Families
# Family, Child
families_ODK <- read_csv('csvs/families.csv')
families <- families_ODK %>% select(family = "_id", child = child_id, source = marriage_id)
write_csv(families, path = 'families.csv')

# Marriages
# Marriage, Husband, Wife, Date, Place (or Placeid), Source, Note
marriages_ODK <- read_csv('csvs/marriages.csv')
marriages <- marriages_ODK %>% select(marriage = "_id", partner1 = person_1, partner2 = person_2, place_id = household_id)
write_csv(marriages,path = 'marriages.csv')



# gephi

gephiPeople <- householdMembers %>% select(id = "_id", firstname = first_name, surname = last_name, gender = sex, residenceplace_id = household_id)
write_csv(gephiPeople, path = "gephiPeople.csv")

gephiMarriages <- marriages_ODK %>% select(id = "_id", source = person_1, target = person_2, place_id = household_id)
write_csv(gephiMarriages,path = 'gephiMarriages.csv')