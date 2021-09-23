library(NeuroBlu)
library(tidyr)
library(ggplot2)

##We load the utilities
source("Utilities.r")




processNonLogitudinal <- function(cohortName) {
  ##The main function to procees the NonLongitudinal Data from a cohort
  ##Input : cohortName = The name of a valid cohort in cohort builder
  ##Outpur: barplot showing the availability of the data
  
  ###First we obtain the patients of the cohort
	patientsCohort <- getCohort(cohortName)
  ##We obtain the data of the non-longitudinal variables
  	dataNonLongitudinal <- getNonLongitudinal(patientsCohort)

  ##We count and summarize the available data
	availableData <- calculateMissing(dataNonLongitudinal, patientsCohort)

  ##We plot the availableData, the name of the file will be barplotUniqueValues
	plotUniqueValues(availableData, "barplotUniqueValues")
  
  }

getNonLongitudinal <- function(patientsCohort) {
  ##Function that obtains and merges all of the tables from non-Longitudinal data
  ##Input: patientsCohort = Vector of patients_id
  ##Output: A dataframe containing all the tables merged
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
  
  	return(dfMergedUnique)

}
