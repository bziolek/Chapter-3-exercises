#Load packages
library(dplyr)
library(tidyr)
library(readr)

#Import dataset and change factors to strings
titanic_original <- read.csv("titanic_original.csv", stringsAsFactors = F)
#View(titanic_original)

#unique_embarked <- distinct(select(titanic_original, embarked))

#1 Port of embarkation
embarkation <- titanic_original
embarkation$embarked[embarkation$embarked ==""] <- "S"


#2 Age
##Calculate mean age, limit to 4 decimals
mean_age <- round(mean(embarkation$age, na.rm = TRUE), digits = 4)

##Replace blank age with mean_age
titanic_age <- embarkation
titanic_age$age[is.na(titanic_age$age)] <- mean_age

#3 Lifeboat
#missing values in the boat column. Fill these empty slots with a dummy value e.g. the string 'None' or 'NA'

lifeboat <- titanic_age 
lifeboat$boat[lifeboat$boat ==""] <- "None"

#4 Cabin
#Create a new column has_cabin_number which has 1 if there is a cabin number, and 0 otherwise.

titanic_cabin <- lifeboat %>% mutate(has_cabin_number = if_else(cabin == "", 0, 1))

#5 Submit the project on Github
write.csv(titanic_cabin, file = "titanic_clean.csv")