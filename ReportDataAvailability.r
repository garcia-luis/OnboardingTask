
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
##Education
education <- getEducationYears(patientsCohort)

###Merged table for unique values variables
dfMergedUnique <- merge(birthYear, employment, by = "person_id", all = TRUE)
dfMergedUnique <- merge(dfMergedUnique, ethnicity, by = "person_id", all = TRUE)
dfMergedUnique <- merge(dfMergedUnique, gender, by = "person_id", all = TRUE)
dfMergedUnique <- merge(dfMergedUnique, marital, by = "person_id", all = TRUE)
dfMergedUnique <- merge(dfMergedUnique, race, by = "person_id", all = TRUE)
dfMergedUnique <- merge(dfMergedUnique, state, by = "person_id", all = TRUE)
dfMergedUnique <- merge(dfMergedUnique, education, by = "person_id", all = TRUE)

###We will change "Unknown" and 0 to NA
dfMergedUnique[dfMergedUnique == "Unknown"] <- NA
dfMergedUnique[dfMergedUnique == 0 ] <- NA
##We calculate the NAs in the variables       
dfUniqueAvailability <- sapply(dfMergedUnique, function(x) sum(is.na(x)))
###We obtain the percentage of availability
dfUniqueAvailability <- as.data.frame((((dfUniqueAvailability - length(patientsCohort)) * -1)*100) / length(patientsCohort))                        
#We change the title of the colname to percentage
colnames(dfUniqueAvailability) <- "percentage" 
#We add a column with the variables names for ggplot                               
dfUniqueAvailability$variableName <- rownames(dfUniqueAvailability)                               

#We plot the availability of the unique values                               
p <-ggplot(data=dfUniqueAvailability, aes(x=variableName, y=percentage)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(angle = 45))
p <- p + labs(title="Data Availability", x ="", y = "% of patients with data")
p <- p + theme(plot.title = element_text(hjust = 0.5))
ggsave('barplotUnique.png', p, dpi=300, width = 10, height = 8)                              
                           
#############Longitudinal and non-unique data
###Stressors
stressors <- getStressors(patientsCohort)
##We count the unique patients that have stressors data
stressorsUnique <- length(unique(stressors$person_id))     
##We make a dataframe to store the values                               
dfLongitudinal <- data.frame("Stressors", stressorsUnique)
colnames(dfLongitudinal) <- c("variable_name", "number_of_patients") 

####For the longitudinal data we will calculate two measurements:
#a)Patients with at least 1 observed clinical variable
#b)observed clinical variables / total visits 

##We first obtain the visits
visits <- getVisit(patientsCohort)
##Next we remove the duplicates by person_id, visit_date
visitsUnique <- unique(visits[c("person_id", "visit_date")])                               
###We add a column to dfLongtudinal containing the total number of observations to be
##considered with the visits
dfLongitudinal$total_number <- 0  
dfLongitudinal[nrow(dfLongitudinal) + 1,] <- c("Visits", length(unique(visitsUnique$person_id)), nrow(visitsUnique))                               
                               
##CGI-I
cgii <- getCGII(patientsCohort) 
                                                       
##We calculate the number of patients with at least one variable observed
##                              
cgii_unique <- length(unique(cgii$person_id))
                               
##We add the number of patients with at least 1 observation and the total number of cgii
##The total_number will be later processed in percentages using the number of visits                               
dfLongitudinal[nrow(dfLongitudinal) + 1,] <- c("CGII", cgii_unique, nrow(cgii)) 

rm(cgii)                               
##CGI-S                               
cgis <- getCGIS(patientsCohort)                               
                                                      
##We calculate the number of patients with at least one variable observed
##                              
cgis_unique <- length(unique(cgis$person_id))  
##We add the number of patients with at least 1 observation and the total number of cgii                               
dfLongitudinal[nrow(dfLongitudinal) + 1,] <- c("CGIS", cgis_unique, nrow(cgis)) 
rm(cgis)
                               
###Derived_MADRS
derived_madrs <- getDerivedMADRS(patientsCohort)                              
derived_madrs_unique <- length(unique(derived_madrs$person_id))                           
dfLongitudinal[nrow(dfLongitudinal) + 1,] <- c("Derived_MADRS", derived_madrs_unique, nrow(derived_madrs))                               
rm(derived_madrs_unique)
###DIAGNOSIS
diagnosis <- getDiagnosis(patientsCohort)
diagnosis_unique <- length(unique(diagnosis$person_id))
###Diagnosis per date 0                               
dfLongitudinal[nrow(dfLongitudinal) + 1,] <- c("diagnosis", diagnosis_unique, 0)   
rm(diagnosis)
##Drug
drug <- getDrug(patientsCohort)                               
drug_unique <- length(unique(drug$person_id)) 
dfLongitudinal[nrow(dfLongitudinal) + 1,] <- c("drug", drug_unique, 0) 
rm(drug)                               
##FamilyHistory                               
familyHistory <- getFamilyHistory(patientsCohort)
familyHistory_unique <- length(unique(familyHistory$person_id))
dfLongitudinal[nrow(dfLongitudinal) + 1,] <- c("familyHistory", familyHistory_unique, 0) 
rm(familyHistory)                               
##GAF
gaf <- getGAF(patientsCohort)                               
gaf_unique <- length(unique(gaf$person_id))     
dfLongitudinal[nrow(dfLongitudinal) + 1,] <- c("GAF", gaf_unique, nrow(gaf)) 
rm(gaf)  
###MADRS
madrs <- getMADRS(patientsCohort)  
if (nrow(madrs) == 0) {
  dfLongitudinal[nrow(dfLongitudinal) + 1,] <- c("MADRS", 0, 0)
} else {
  
  
  dfLongitudinal[nrow(dfLongitudinal) + 1,] <- c("MADRS", length(unique(madrs$person_id)), nrow(madrs_unique))
                                                                        
  
}                          
rm(madrs)  
                               
##RSAV
rsav <- getRSAV(patientsCohort)
rsav_unique <- length(unique(rsav$person_id))
dfLongitudinal[nrow(dfLongitudinal) + 1,] <- c("RSAV", rsav_unique, nrow(rsav)) 
rm(rsav)  

##SAV
sav <- getSAV(patientsCohort)
sav_unique <- length(unique(sav$person_id))
dfLongitudinal[nrow(dfLongitudinal) + 1,] <- c("SAV", sav_unique, nrow(sav)) 
rm(sav)                               
##SmoothCGIS
smoothCGIS <- getSmoothCGIS(patientsCohort)
smoothCGIS_unique <- length(unique(smoothCGIS$person_id)) 
dfLongitudinal[nrow(dfLongitudinal) + 1,] <- c("SmoothCGIS", smoothCGIS_unique, nrow(smoothCGIS))                               
rm(smoothCGIS)    
                               

###Next we calculate the percentage of data availability                              
dfLongitudinal$percentage_available <- (as.numeric(dfLongitudinal$number_of_patients) * 100) / length(patientsCohort)         
write.csv(dfLongitudinal, "dfLongitudinal.csv")
##Plot
#We plot the availability of the unique values
p2 <-ggplot(data=dfLongitudinal, aes(x=variable_name, y=percentage_available)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(angle = 45))
p2 <- p2 + labs(title="Data Availability", x ="", y = "% of patients with data")
p2 <- p2 + theme(plot.title = element_text(hjust = 0.5))
ggsave('barplotUnique.png', p2, dpi=300, width = 10, height = 8)