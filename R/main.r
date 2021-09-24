# This template demonstrates how to get the available data from a given cohort
# To run this analysis for a different cohort and type of visits, modify 
# the variables cohort_name, type_of_visits and run the code.
# By default, cohort_name is “test”
##b


### ----------  CONFIGURATION SETTINGS ----------  

# Enter the name of the cohort
cohort_name <- "test"

#Enter the type of visits to analyze
type_of_visits <- c("Emergency Room and Inpatient Visit",
                   "Inpatient Visit", "Outpatient Visit",
                   "Health examination")


### ----------  END CONFIGURATION ----------
source("Process_NonLongitudinal.r")
source("Process_Longitudinal.r")

processNonLogitudinal(cohort_name)
processLongitudinal(cohort_name, type_of_visits)
