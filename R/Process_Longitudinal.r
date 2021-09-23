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
  	patientsCohort <- patientsCohort[1:10]
  
  ##We obtain the data and the patients with at least 1 observation
  print("Obtaining data")
  
  data <- getLongitudinalData(patientsCohort, type_of_visits)
  
  ###Next we calculate the percentage of data availability 
  availability <- getPercentage(data, patientsCohort)
  
  ##Finally we plot the data
  plotLongitudinalValues(availability, "barplotLongitudinal")
  
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
	#visits <- getVisit(patientsCohort)
	##Next we remove the duplicates by person_id, visit_date
	#visitsUnique <- unique(visits[c("person_id", "visit_date")]) 
  	#visitsUnique <- getUnique(visitsUnique)
	###We add a column to dfLongtudinal containing the total number of observations to be
	##considered with the visits
	#dfLongitudinal$total_number <- 0 
  	#We update the dfLongitudinal with the values of the visits
  	#dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "Visits", visitsUnique, nrow(visits))
  
  	#####
  	queryVisits <- queryVisits(patientsCohort,type_of_visits)
  	visits <- getQuery(queryVisits)
  	visitsUnique <- unique(visits[c("person_id", "visit_occurrence_id", "concept_name")])
  	##NEEDS TO REFACTOR
  	dfVisitsCounts <- visitsUnique %>% count(concept_name)
  	write.csv(dfVisitsCounts, "VisitsCountsByType.csv")
  	dfVisitsCounts$n <- (dfVisitsCounts$n * 100) / sum(dfVisitsCounts$n)
  	plotVisits(dfVisitsCounts)
  	visitsUnique <- getUnique(visitsUnique)
  	dfLongitudinal$total_number <- 0
  	dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "Visits", visitsUnique, nrow(visits))
  	#####
  	
  	
  	##CGI-I
  	print("CGI-I")
	cgii <- getCGII(patientsCohort)                                                 
	##We calculate the number of patients with at least one variable observed                             
	cgii_unique <- getUnique(cgii)                         
	##We add the number of patients with at least 1 observation and the total number of cgii
	##The total_number will be later processed in percentages using the number of visits
    dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "CGII", cgii_unique, nrow(cgii))
	rm(cgii)
  
  
  	##CGI-S  
  	print("CGI-S")
	cgis <- getCGIS(patientsCohort)                                                                              
	##We calculate the number of patients with at least one variable observed
	##                              
	cgis_unique <- getUnique(cgis)  
	##We add the number of patients with at least 1 observation and the total number of cgii                               
	dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "CGIS", cgis_unique, nrow(cgis))
	rm(cgis)
  
  	###Derived_MADRS
  	print("Derived MADRS")
	derived_madrs <- getDerivedMADRS(patientsCohort)                              
	derived_madrs_unique <- getUnique(derived_madrs)                          
	dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "Derived_MADRS", derived_madrs_unique, nrow(derived_madrs))                               
	rm(derived_madrs_unique)
  	###DIAGNOSIS
  	print("Diagnosis")
	diagnosis <- getDiagnosis(patientsCohort)
	diagnosis_unique <- getUnique(diagnosis)
	###Diagnosis per date 0                               
	dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "diagnosis", diagnosis_unique, 0)     
	rm(diagnosis)
  
  	##Drug
  	print("Drug")
	drug <- getDrug(patientsCohort)                               
	drug_unique <- getUnique(drug)
	dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "drug", drug_unique, 0)     
	rm(drug) 
  
  	##FamilyHistory
  	print("Family History")
	familyHistory <- getFamilyHistory(patientsCohort)
	familyHistory_unique <- getUnique(familyHistory)
	dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "familyHistory", familyHistory_unique, 0)     
	rm(familyHistory) 
  
  	##GAF
  	print("GAF")
	gaf <- getGAF(patientsCohort)                               
	gaf_unique <- getUnique(gaf)    
	dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "gaf", gaf_unique, nrow(gaf))     
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
  
  	##RSAV
  	print("RSAV")
	rsav <- getRSAV(patientsCohort)
  	dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "RSAV", getUnique(rsav), nrow(rsav))
	rm(rsav)
  
    ##SAV
  	print("SAV")
	sav <- getSAV(patientsCohort)
  	dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "sav", getUnique(sav), nrow(sav))
	rm(sav)
  
  	##SmoothCGIS
  	print("SmoothCGIS")
	smoothCGIS <- getSmoothCGIS(patientsCohort)
    dfLongitudinal <- updateDfLongitudinal(dfLongitudinal, "SmoothCGIS", getUnique(smoothCGIS), nrow(smoothCGIS))
	rm(smoothCGIS)
  
  	return(dfLongitudinal)

}

getPercentage <- function (df, patientsCohort) {
  #Function that receives a Dataframe containing the number of patients
  #with data available and obtains the percentage considering the size
  #of the cohort in cohort builder
  
  df$percentage_available <- (as.numeric(df$number_of_patients) * 100) / length(patientsCohort)  
  write.csv(df, "dfLongitudinal.csv")
  return(df)
  


}
