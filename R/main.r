# This template demonstrates how to get the available data from a given cohort
# To run this analysis for a different cohort and type of visits, modify
# the variables cohort_name, type_of_visits and run the code.
# By default, cohort_name is “test”
#V2.0


### ----------  CONFIGURATION SETTINGS ----------

# Enter the name of the cohort
cohort_name <- "test"

#Enter the type of visits to analyze
type_of_visits <- c("Emergency Room and Inpatient Visit",
                   "Inpatient Visit", "Outpatient Visit",
                   "Health examination")


### ----------  END CONFIGURATION ----------
library(NeuroBlu)
library(tidyr)
library(ggplot2)
library(dplyr)

source("Process_NonLongitudinal.r")
source("Process_Longitudinal.r")
source("Utilities.r")

processNonLogitudinal(cohort_name)
processLongitudinal(cohort_name, type_of_visits)
