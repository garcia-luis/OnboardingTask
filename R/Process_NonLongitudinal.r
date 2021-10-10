
##We load the utilities
source("Utilities.r")




processNonLogitudinal <- function(cohortName) {
  # The main function to process the NonLongitudinal Data from a cohort
  # Input : cohortName = The name of a valid cohort in cohort builder
  ##Output: barplot showing the availability of the data

  ###First we obtain the patients of the cohort
	patientsCohort <- getCohort(cohortName)
  ##We obtain the data of the non-longitudinal variables
  	dataNonLongitudinal <- getNonLongitudinal(patientsCohort)

  ##We count and summarize the available data
	availableData <- calculateMissing(dataNonLongitudinal, patientsCohort)

  ##We order the available data
  	availableData <- arrange(availableData, desc(percentage))
  ##We clean the variable names
  	availableData <- clean_names(availableData)

  ##We save the table
    write.csv(availableData, "Table_Available_Data_NonLongitudinal.csv",
             row.names = F)

  ##We plot the availableData, the name of the file will be barplotUniqueValues
	plotUniqueValues(availableData, "Percentage_Available_Data_NonLongitudinal")

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

  	dfMergedUnique <- subset(dfMergedUnique, select=-c(person_id))


  	return(dfMergedUnique)

}

 clean_names <- function(availableData){
 	availableData$variableName <- gsub("years_in_education", "Education years", availableData$variableName, fixed=TRUE)
 	availableData$variableName <- gsub("birth_year", "Year of birth", availableData$variableName, fixed=TRUE)
 	availableData$variableName <- gsub("ethnicity", "Ethnicity", availableData$variableName, fixed=TRUE)
 	availableData$variableName <- gsub("gender", "Gender", availableData$variableName, fixed=TRUE)
 	availableData$variableName <- gsub("marital_status", "Marital status", availableData$variableName, fixed=TRUE)
 	availableData$variableName <- gsub("state", "State", availableData$variableName, fixed=TRUE)
 	availableData$variableName <- gsub("race", "Race", availableData$variableName, fixed=TRUE)
 	availableData$variableName <- gsub("employment_status", "Employment_status", availableData$variableName, fixed=TRUE)
    availableData <- availableData[,c(2,1)]
    colnames(availableData)[1] <- "Variables"
   return(availableData)

 }
