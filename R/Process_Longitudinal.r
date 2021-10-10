source("Utilities.r")


processLongitudinal <- function(cohortName, type_of_visits) {
  ##The main function to procees the Longitudinal Data from a cohort
  ##Input : cohortName = The name of a valid cohort in cohort builder
  ##Output: barplot showing the availability of the data

  ####For the longitudinal data we will calculate two measurements:
	#a)Patients with at least 1 observed clinical variable
	#b)observed clinical variables / total visits

    ###First we obtain the patients of the cohort
  patientsCohort <- getCohort(cohortName)
  patientsCohort <- getCohort(cohortName)
  ##We obtain the data and the patients with at least 1 observation
  print("Obtaining data")

  data <- getLongitudinalData(patientsCohort, type_of_visits)

  ###Next we calculate the percentage of data availability
  availability <- getPercentage(data, patientsCohort)

  ##Finally we plot the data
  plotLongitudinalValues(availability, "Percentage_Available_Data_Longitudinal")

  }

getLongitudinalData <- function(patientsCohort, type_of_visits){
	##Function that receives a valid patienstCohort vector, obtains the
 	##Longitudinal data

  	###Stressors
  	print("Stressors")
	stressors <- getStressors(patientsCohort)
  	stressorsUnique <- getUnique(stressors)
	##We make a dataframe to store the values
	dfLongitudinal <- data.frame("Stressors", stressorsUnique)
	colnames(dfLongitudinal) <- c("variable_name", "number_of_patients")
  	rm(stressors, stressorsUnique)

  	##We obtain the visits
  	print("Visits")
  	#####
  	queryVisits <- queryVisits(patientsCohort,type_of_visits)
  	visits <- getQuery(queryVisits)
  	visitsUnique <- unique(visits[c("person_id", "visit_occurrence_id", "concept_name")])
  	##NEEDS TO REFACTOR
  	dfVisitsCounts <- visitsUnique %>% count(concept_name)
  	dfVisitsCounts$Percentage_available <- (dfVisitsCounts$n * 100) / sum(dfVisitsCounts$n)
  	dfVisitsCounts <- subset(dfVisitsCounts, select= -c(n))
  	colnames(dfVisitsCounts)[1] <- "Variables"
  	dfVisitsCounts <- arrange(dfVisitsCounts, Percentage_available)
  	write.csv(dfVisitsCounts, "Table_Available_Data_Visits.csv")

  	plotVisits(dfVisitsCounts, "Percentage_Available_Data_Visits")
  	visitsUnique <- getUnique(visitsUnique)
  	dfLongitudinal$total_number <- 0
  	dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "Visits", visitsUnique, nrow(visits))
  	#####

  	##CGI-S
  	print("CGI-S")
	cgis <- getCGIS(patientsCohort)
	##We calculate the number of patients with at least one variable observed
	##
	cgis_unique <- getUnique(cgis)
	##We add the number of patients with at least 1 observation and the total number of cgii
	dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "CGIS", cgis_unique, nrow(cgis))
	rm(cgis)

  	###DIAGNOSIS
  	print("Diagnosis")
	diagnosis <- getDiagnosis(patientsCohort)
	diagnosis_unique <- getUnique(diagnosis)
	###Diagnosis per date 0
	dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "Diagnosis", diagnosis_unique, 0)
	rm(diagnosis)

  	##Drug
  	print("Drug")
	drug <- getDrug(patientsCohort)
	drug_unique <- getUnique(drug)
	dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "Drug", drug_unique, 0)
	rm(drug)

  	##FamilyHistory
  	print("Family History")
	familyHistory <- getFamilyHistory(patientsCohort)
	familyHistory_unique <- getUnique(familyHistory)
	dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "Family history", familyHistory_unique, 0)
	rm(familyHistory)

  	##GAF
  	print("GAF")
	gaf <- getGAF(patientsCohort)
	gaf_unique <- getUnique(gaf)
	dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "GAF", gaf_unique, nrow(gaf))
	rm(gaf)

  	###MADRS
  	print("MADRS")
	madrs <- getMADRS(patientsCohort)
	if (nrow(madrs) == 0) {
  		dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "MADRS", 0, 0)
		} else {
      	dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "MADRS", getUnique(madrs), nrow(madrs))
	}
	rm(madrs)

  	return(dfLongitudinal)

}

getPercentage <- function (df, patientsCohort) {
  #Function that receives a Dataframe containing the number of patients
  #with data available and obtains the percentage considering the size
  #of the cohort in cohort builder

  df$percentage_available <- (as.numeric(df$number_of_patients) * 100) / length(patientsCohort)

  df <- select(df, variable_name, percentage_available) %>% arrange(percentage_available)
  colnames(df) <- c("Variables","Percentage available")
  write.csv(df, "Table_Available_Data_Longitudinal.csv")
  colnames(df)[2] <- "Percentage_available"

  return(df)



}
