<!-- title: Household Census Questions and Variables --> 

Household Census Questions and Variables
========================================
This document contains all census questions and their allocated variables.
A useful reference for field workers and data analysts.

___
**Household ID generation:**
*This is best be done outside of the home to be surveyed*

| Question                                          |      Variable      |       Type       |
| ------------------------------------------------- | :----------------: | :--------------: |
| Take a picture of the house from outside:         |  household_image   |                  |
| Capture the GPS coordinates of the house:         |      location      |                  |
| Select the village where the houshold is located: | household_village  | string from list |
| Add readable household ID:                        | household_human_id |      string      |

**Customary membership**

| Question     |     Variable     |  Type  |
| ------------ | :--------------: | :----: |
| Tokatoka:    |     tokatoka     | string |
| Yavusa:      |      yavusa      | string |
| Mataqali:    |    mataquali     | string |
| Extra notes: | membership_notes | string |

___

**Household Member:**

**Basic demography**

| Question                                                   |    Variable    |  Type  |
| ---------------------------------------------------------- | :------------: | :----: |
| Household member's first name:                             |   first_name   | string |
| Household member's last name:                              |   last_name    | string |
| Are they known by any other name?                          |      aka       | string |
| Age:                                                       |      age       |  int   |
| Sex:                                                       |      sex       | string |
| Does this person live here full time?                      | lives_fulltime | string |
| Please add any relevant information to help data analysis: |     notes      | string |
| Is this person alive?                                      |    is_alive    | string |

**Demography continued:**

*Note: the terms **member** and **member's** are replaced by the persons name in the forms.*

  | Question                                                        |     Variable     |       Type       |
  | --------------------------------------------------------------- | :--------------: | :--------------: |
  | What is the **member's** relation to the head of the household? | relation_to_head | string from list |
  | Where was the **member** born?                                  |    birthplace    |      string      |
  | What is the **member's** marital status?                        |  marital_status  | string from list |
  | How many years education has the **member** had?                | education_years  |       int        |
  | Does **member** have any children?                              |   has_children   |      string      |
  | Please take a photo of the household member.                    |   person_photo   |                  |

___

**Marriages:**
In this section we create links between two people from our **household member roster**.

*If the second person does not live in the household, we create a new member record via the **Household Member** form, linked at the bottom of this screen.*
*Add as many entries as needed to cover all relationships resulting in offspring.*

| Prompt                                                                                                                |  Variable   |       type       |
| :-------------------------------------------------------------------------------------------------------------------- | :---------: | :--------------: |
| Person 1:                                                                                                             |  person_1   |  string (uuid)   |
| Person 2:                                                                                                             |  person_2   |  string (uuid)   |
| What is their current marital status?                                                                                 |    mstat    | string from list |
| *Hidden operation outputs a name for the marriage by combining the peoples names and marital status separated by "_"* | marriage_id |      string      |

___

**Families**
In this section we create links between a marriage and one of it's resultant offspring.

*If the offspring does not live in the household, we create a new member record via the **Household Member** form, linked at the bottom of this screen.*
*Add as many entries needed to cover all offspring resulting from each marriage*

| Prompt                                                                            |  Variable   |  type  |
| :-------------------------------------------------------------------------------- | :---------: | :----: |
| Marriage:                                                                         | marriage_id | string |
| Child:                                                                            |  child_id   | string |
| *Hidden operation outputs a name for the tie, " marriage_name = the child_name "* |  family_id  | string |

___

*Asset Wealth:*
| Prompt                                                            |   Variable   |         type         |
| :---------------------------------------------------------------- | :----------: | :------------------: |
| Select which of the following items are present in the household: | asset_wealth | comma separated list |

**ToDo:** *The items shown in the survey have been generated by a freelisting questionnaire* 

___

**Income:**

| Question                                              |       Variable       |  Type  |
| ----------------------------------------------------- | :------------------: | :----: |
| How much money did you earn in the past week?         |  income_head_amount  |  int   |
| How did you earn this money?                          |  income_head_source  | string |
| How much money did your spouse earn in the past week? | income_spouse_amount |  int   |
| How did they earn this money?                         | income_spouse_source | string |

___

**Food Security**
| Question                                                                   |   Variable    |         Type          |
| -------------------------------------------------------------------------- | :-----------: | :-------------------: |
| In the last year has your household had enough food for three meals a day? | food_security | int (ranked from 1-6) |

___

**Crops and Fishing**

| Question                                                                       |   Variable    | Type  |
| ------------------------------------------------------------------------------ | :-----------: | :---: |
| Approximately how many kava plants do you have currently under cultivatation?  |  crops_kava   |  int  |
| Approximately how many taro plants do you have currently under cultivation?    |  crops_taro   |  int  |
| Approximately how many cassava plants do you have currently under cultivation? | crops_cassava |  int  |
| In an average week, how many days do members of your household go fishing?     |   fish_days   |  int  |
| On average, how many fish are caught when out fishing?                         |  fish_catch   |  int  |

___
