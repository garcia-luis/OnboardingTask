####Utilites to obtain the availability of the data
####

library(ggplot2)


calculateMissing <- function(dfMergedUnique, patientsCohort){
  	#Function that receives a dataframe containing the non-longitudinal data
  	#Replaces "Unknown" and "0" values to NA and counts the missing data
  	#Input: df = Dataframe obtained by merging data using the getter functions
  	#		of NeuroBlu
  	#		patientsCohort = vector of person_ids obtained from cohort builder
  	#Output: A dataframe containing the available data

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

	return(dfUniqueAvailability)

  }


plotUniqueValues <- function(df, nameOfPlot = NULL){
  ##Function that receives a dataframe from calculateMissing() and plots
  ##barplots showing the availability of the data in percentage
  ##Input : df = Summarized dataframe from calculateMissing()
  ##		nameOfPlot = character string containing the name to save the plot
  ##Output: A ggplot2 barplot


  	p <-ggplot(data=df, aes(x=reorder(Variables, percentage), y=percentage)) + geom_bar(stat="identity") #+ theme(axis.text.x = element_text(angle = 0))
	p <- p + labs(title="Available data", x ="", y = "Percentage of patients (%)")
	p <- p + theme(plot.title = element_text(hjust = 0.5)) + coord_flip()
  	if(length(nameOfPlot) == 0){nameOfPlot = "barplotNonLongitudinal.png"} else {nameOfPlot = paste0(nameOfPlot, ".png")}

	ggsave(nameOfPlot, p, dpi=300, width = 10, height = 8)

}


plotLongitudinalValues <- function(df, nameOfPlot = NULL){
  ##Function that receives a dataframe from longitudinal values and plots
  ##barplots showing the availability of the data in percentage
  ##Input : df = dataframe from longitudinal values
  ##		nameOfPlot = character string containing the name to save the plot
  ##Output: A ggplot2 barplot


  	p <-ggplot(data=df, aes(x=reorder(Variables, Percentage_available), y=Percentage_available)) + geom_bar(stat="identity") #+ theme(axis.text.x = element_text(angle = 90))
	p <- p + labs(title="Available data", x ="", y = "Percentage of patients (%)")
	p <- p + theme(plot.title = element_text(hjust = 0.5)) + coord_flip()
  	if(length(nameOfPlot) == 0){nameOfPlot = "barplotlongitudinal.png"} else {nameOfPlot = paste0(nameOfPlot, ".png")}

	ggsave(nameOfPlot, p, dpi=300, width = 10, height = 8)

}

getUnique <- function(df) {
  ##Function that receives a dataframe obtained by the getter methods,
  ##and returns the count of unique person_id
  ##Input: df = a dataframe
  return(length(unique(df$person_id)))
}

updateDfLongitudinal <- function(df, variableName, value1, value2){
	##Function that receives a dataframe from the Longitudinal data and
  	##adds a new row
  	##Input: df = a dataframe
  	##		 variableName = a character
  	##		value1 and value2 = integers
  	##Output: The updated dataframe

  	df[nrow(df) + 1,] <- c(variableName, value1, value2)
  	return(df)

}



vectorToSQL <- function(vector, addQuote = FALSE){
  #Receives a vector and returns a character
  #separated by commas to use in SQL Querys
  #Input: Vector of person_ids
  #Output: Comma separated character
  if (addQuote == TRUE) {
    vector = paste0('"', vector, '"')
    }

  return(paste(vector,collapse=", ",sep=""))
  }



queryVisits <- function(patients, typeOfVisit = NULL){
  ##Receives a vector of person_ids and a concept_name for visits
  ##and returns a dataframe containing the persons_ids visits and the
  ##type of visits
  ##Input: patients = vector of persons_id
  ##	   typeOfVisit = character vector from a valid visit concept_name
  ##       If null it returns all the available concept_name
  ##Returns: A dataframe containing the person_id and concept_name including
  ##the type of visit

  queryPatients <- vectorToSQL(patients)
  query <- c("SELECT vo.person_id, vo.visit_occurrence_id, c.concept_id, c.concept_name FROM visit_occurrence vo JOIN concept c ON vo.visit_concept_id = c.concept_id WHERE vo.person_id IN (")
  finalQuery <- paste0(query, queryPatients, ")")

  if (length(typeOfVisit) != 0) {
    visitsSQL <- vectorToSQL(typeOfVisit, TRUE)
    finalQuery <- paste0(finalQuery, " AND c.concept_name IN (", visitsSQL,")")
    }

  return(finalQuery)

  }

plotVisits <- function(df, nameOfPlot = "VisitsDistribution"){
  ##Function that receives a dataframe from visits values and plots
  ##barplots showing the availability of the data
  ##Input : df = dataframe from visits values
  ##		nameOfPlot = character string containing the name to save the plot
  ##Output: A ggplot2 barplot


  	p <-ggplot(data=df, aes(x=reorder(Variables, Percentage_available), y=Percentage_available)) + geom_bar(stat="identity") #+ theme(axis.text.x = element_text(angle = 90))
	p <- p + labs(title="Visits Data Availability", x ="", y = "% of ocurrences")
	p <- p + theme(plot.title = element_text(hjust = 0.5)) + coord_flip()
  	if(length(nameOfPlot) == 0){nameOfPlot = "barplotlongitudinal.png"} else {nameOfPlot = paste0(nameOfPlot, ".png")}

	ggsave(nameOfPlot, p, dpi=300, width = 10, height = 8)

} 
