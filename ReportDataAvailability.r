library(NeuroBlu)
library(tidyr)
library(ggplot2)

listAvailableCohorts()


###First we obtain the patients of the cohort
patientsCohort <- getCohort("test")


######Variables with unique values
##BirthYear

birthYear <- getBirthYear(patientsCohort)
       
###Employment
employment <- getEmployment(patientsCohort)
#Ethnicity
ethnicity <- getEthnicity(patientsCohort)
##Gender
gender <- getGender(patientsCohort)
##Marital
marital <- getMarital(patientsCohort)
##Race
race <- getRace(patientsCohort)      
##State
state <- getState(patientsCohort)
###Merged table for unique values variables
dfMergedUnique <- merge(birthYear, employment, by = "person_id", all = TRUE)
dfMergedUnique <- merge(dfMergedUnique, ethnicity, by = "person_id", all = TRUE)
dfMergedUnique <- merge(dfMergedUnique, gender, by = "person_id", all = TRUE)
dfMergedUnique <- merge(dfMergedUnique, marital, by = "person_id", all = TRUE)
dfMergedUnique <- merge(dfMergedUnique, race, by = "person_id", all = TRUE)
dfMergedUnique <- merge(dfMergedUnique, state, by = "person_id", all = TRUE)

###We will change "Unknown" to NA
dfMergedUnique[dfMergedUnique == "Unknown"] <- NA
##We calculate the NAs in the variables       
dfUniqueAvailability <- sapply(dfMergedUnique, function(x) sum(is.na(x)))
###We obtain the percentage of availability
dfUniqueAvailability <- as.data.frame((((dfUniqueAvailability - length(patientsCohort)) * -1)*100) / length(patientsCohort))                        
#We change the title of the colname to percentage
colnames(dfUniqueAvailability) <- "percentage" 
#We add a column with the variables names for ggplot                               
dfUniqueAvailability$variableName <- rownames(dfUniqueAvailability)                               

#We plot the availability                               
p <-ggplot(data=dfUniqueAvailability, aes(x=variableName, y=percentage)) + geom_bar(stat="identity") + ggtitle("Data Availability")
ggsave('barplotUnique.png', p, dpi=300)                              
                           
###Stressors needs to be manually processed
####Function 





