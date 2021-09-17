
<!-- title: Social Network Questions and Variables --> 

Social Network Questions and Variables
========================================
This document contains all of the Social Network form questions and their allocated fields/variables.
A useful reference for field workers and data analysts.

___

**Participant information**

*Gather information about the participant to link them to the household_members database.*

| Question                                            |        Field         |           Type           |
| --------------------------------------------------- | :------------------: | :----------------------: |
| Name:                                               | participant_fullname |           Text           |
| Sex:                                                |   participant_sex    |           Text           |
| Location:                                           | participant_location | Choice of village (Text) |
| Visit number:                                       |     visit_number     |           Int            |
| Find the participants UUID in the confirmation app: |   participant_uuid   |           Text           |

___
**A note on the confirmation sections and naming convention of the fields used**

At various points during the questionnaire, the interviewer will be asked to confirm the person the participant put down as an answer.
To do this, the interviewer will open the *CCSocial* app, search for the person, confirm it is them, and copy the UUID into the questionnaire.

*If the person nominated does not exist in the database, please create a new entry for them using the linked form, save their information, then return to the **CCSocial** app to find their UUID as normal.*

The field in which the uuid is pasted into will be named the same as the question it relates to, followed by ```_uuid```.
For example: The beginning of the fields for question 1 is ```cq1_1```, followed by ```_1_``` (the ranking), then ```_name```(name of the person being listed) or ```item``` (the item borrowed). 
In this case, the uuid of the person being listed will be stored in the field ```cq1_1_uuid```.

---
Cooperation Questions:
===

**1: Think of the people who you have borrowed household items from recently [meaning salt or pots]?**

*Who are these people, and what did you borrow from them?*

*The item dropdown choices are populated by the freelisting census*
| Question | Field      | Type                               |
| -------- | ---------- | ---------------------------------- |
| Name:    | cq1_1_name | Text                               |
| Item:    | cq1_1_item | Choice from list (Text)            |
| uuid:    | cq1_1_uuid | Text (copy uuid from CCSocial app) |
| ...      |            |
| Name     | cq1_5_name |                                    |
| Item:    | cq1_5_item |                                    |
| uuid:    | cq1_5_uuid |                                    |

---

**2: Sometimes we all need to borrow small amounts of money (e.g. $2).**

*Think back to some recent times you've borrowed a small amount of money from someone, who did you borrow money from, and how much did you borrow?*

| Question | Field        | Type                               |
| -------- | ------------ | ---------------------------------- |
| Name:    | cq2_1_name   | Text                               |
| Amount:  | cq2_1_amount | Int                                |
| uuid:    | cq2_1_uuid   | Text (copy uuid from CCSocial app) |
| ...      |              |
| Name:    | cq2_5_name   |
| Amount:  | cq2_5_amount |
| uuid:    | cq2_5_uuid   |

---

**3: Sometimes we all need to borrow larger amounts of money (e.g. more than $20).**

*Think back to some recent times you've borrowed a large amount of money from someone, who did you borrow money from, and how much did you borrow?*

| Question | Field        | Type                               |
| -------- | ------------ | ---------------------------------- |
| Name:    | cq3_1_name   | Text                               |
| Amount:  | cq3_1_amount | Int                                |
| uuid:    | cq3_1_uuid   | Text (copy uuid from CCSocial app) |
| ...      |              |
| Name:    | cq3_5_name   |                                    |
| Amount:  | cq3_5_amount |                                    |
| uuid:    | cq3_5_uuid   |                                    |

---

**4: Think back to the last time someone gave you food.**

*Who gave you food and what kind of food did they give you?*

| Question | Field      | Type                               |
| -------- | ---------- | ---------------------------------- |
| Name:    | cq4_1_name | Text                               |
| Food:    | cq4_1_food | Text                               |
| uuid:    | cq4_1_uuid | Text (copy uuid from CCSocial app) |
| ...      |            |                                    |
| Name:    | cq4_5_name |                                    |
| Food:    | cq4_5_food |                                    |
| uuid:    | cq4_5_uuid |                                    |

---

**Cooperation Questions for Men:**
===

**1: Think of people who have helped you with physical tasks recently [meaning planting crops, or building something]?**

*Who are these people, and what did they help you with?*

| Question: | Field       | Type                               |
| --------- | ----------- | ---------------------------------- |
| Name:     | cqm1_1_name | Text                               |
| Task:     | cqm1_1_task | Text                               |
| uuid:     | cqm1_1_uuid | Text (copy uuid from CCSocial app) |
| ...       |             |                                    |
| Name:     | cqm1_5_name |                                    |
| Task:     | cqm1_5_task |                                    |
| uuid:     | cqm1_5_uuid |                                    |

---

**2: Sometimes events such as funerals or weddings require that people bring kava, pigs and/or cows.**

*Have you recently needed to borrow Foods such as these? If so, whom did you borrow these from and what did you borrow?*

| Question | Field       | Type                               |
| -------- | ----------- | ---------------------------------- |
| Name:    | cqm2_1_name | Text                               |
| Food:    | cqm2_1_food | Text                               |
| uuid:    | cqm2_1_uuid | Text (copy uuid from CCSocial app) |
| ...      |             |                                    |
| Name:    | cqm2_5_name |                                    |
| Food:    | cqm2_5_food |                                    |
| uuid:    | cqm2_5_uuid |                                    |

---
Cooperation Questions for Women
===

**1: Think of people who have helped you with housework recently [meaning cleaning the house or laundry]?**

*Who are these people, and what did they help you with?*

| Question: | Field       | Type                               |
| --------- | ----------- | ---------------------------------- |
| Name:     | cqf1_1_name | Text                               |
| Task:     | cqf1_1_task | Text                               |
| uuid:     | cqf1_1_uuid | Text (copy uuid from CCSocial app) |
| ...       |             |                                    |
| Name:     | cqf1_5_name |                                    |
| Task:     | cqf1_5_task |                                    |
| uuid:     | cqf1_5_uuid |                                    |

---

**2: Sometimes mats are needed for social functions such as weddings, but mats can take a long time to make, so we need to borrow mats from someone.**

*Have you recently needed to borrow mats from someone recently, and if so, from whom?*

| Question: | Field       | Type                               |
| --------- | ----------- | ---------------------------------- |
| Name:     | cqf2_1_name | Text                               |
| uuid:     | cqf2_1_uuid | Text (copy uuid from CCSocial app) |
| ...       |             |                                    |
| Name:     | cqf2_5_name |                                    |
| uuid:     | cqf2_5_uuid |                                    |

---

Social Network Questions:
===

**1: If you want to talk about important matters, who do you talk to (men or women)?**

| Question: | Field       | Type                               |
| --------- | ----------- | ---------------------------------- |
| Name:     | snq1_1_name | Text                               |
| uuid:     | snq1_1_uuid | Text (copy uuid from CCSocial app) |
| ...       |             |                                    |
| Name:     | snq1_5_name |                                    |
| uuid:     | snq1_5_uuid |                                    |

---

**2: If you had to spend a lot of time talking to someone, who would you like to talk with (men or women)?**

| Question: | Field       | Type                               |
| --------- | ----------- | ---------------------------------- |
| Name:     | snq2_1_name | Text                               |
| uuid:     | snq2_1_uuid | Text (copy uuid from CCSocial app) |
| ...       |             |                                    |
| Name:     | snq2_5_name |                                    |
| uuid:     | snq2_5_uuid |                                    |

---
**3: If any problem happens, who are the people that will help you (men or women)?**

| Question: | Field       | Type                               |
| --------- | ----------- | ---------------------------------- |
| Name:     | snq3_1_name | Text                               |
| uuid:     | snq3_1_uuid | Text (copy uuid from CCSocial app) |
| ...       |             |                                    |
| Name:     | snq3_5_name |                                    |
| uuid:     | snq3_5_uuid |                                    |

---
**4: Who are the people who give you advice (men or women)?**

| Question: | Field       | Type                               |
| --------- | ----------- | ---------------------------------- |
| Name:     | snq4_1_name | Text                               |
| uuid:     | snq4_1_uuid | Text (copy uuid from CCSocial app) |
| ...       |             |                                    |
| Name:     | snq4_5_name |                                    |
| uuid:     | snq4_5_uuid |                                    |

---

Religion Questions
===

*This section is only asked on the first vist.*
| Question:                                                                             | Field                                 | Type |
| ------------------------------------------------------------------------------------- | ------------------------------------- | ---- |
| What religion were you growing up?                                                    | participant_religion_upbringing       | Text |
| Have you ever been the member of another church besides the one you currently attend? | participant_religion_otherChurch      | Text |
| What was the church before the one you currently attend?                              | participant_religion_previousChurch   | Text |
| How long ago did you switch to your current church?                                   | participant_religion_switchedChurch   | Text |
| Have you ever been the member of other churches?                                      | participant_religion_otherChurches    | Text |
| Please list previous churches, separated by a comma:                                  | participant_religion_previousChurches | Text |

---

**Religion Questions Continued...**
*The following questions are asked on each visit*

| Question:                                                                  | Field                                  | Type                 |
| -------------------------------------------------------------------------- | -------------------------------------- | -------------------- |
| How many times did you pray in the past week?                              | participant_religion_prayedPerWeek     | Int                  |
| In the past week, how many times did you attend church?                    | participant_religion_churchPerWeek     | Int                  |
| What church did you attend?                                                | participant_religion_churchAttended    | Text                 |
| At each service, about how many people attend your house of worship?       | participant_religion_serviceAttendance | Int                  |
| In the past week, how much money did you contribute to your local church?  | participant_religion_donationWeek      | Int                  |
| In the past month, how much money did you contribute to your local church? | participant_religion_donationMonth     | Int                  |
| Do you serve in any roles at the church (e.g., choir)?                     | participant_religion_role              | Yes/No choice (Text) |
| ```if yes``` What roles do you serve at your church?                       | participant_religion_roleDetails       | Text                 |

---

The Last Question
===

| Question:                                                                                                                                         | Field                                | Type |
| ------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ | ---- |
| In the past 9 months has your household purchased any household items (such as furniture or fans)? If so, list these items, separated by a comma: | participant_household_itemsPurchased | Text |