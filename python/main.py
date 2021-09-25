# This template demonstrates how to get the available data from a given cohort
# To run this analysis for a different cohort and type of visits, modify 
# the variables cohort_name, type_of_visits and run the code.
# By default, cohort_name is “Cohort For Onboarding Task”

### ----------  CONFIGURATION SETTINGS ----------  

# Enter the name of the cohort
cohort_name = "Cohort For Onboarding Task"

#Enter the type of visits to analyze
type_of_visits = ["Emergency Room and Inpatient Visit","Inpatient Visit",
                  "Outpatient Visit", "Health examination"]

### ----------  END CONFIGURATION ----------

#Call functions to process longitudinal data
exec(open("Process_NonLongitudinal.py").read())

#Call functions to process non longitudinal data
exec(open("Process_Longitudinal.py").read())

#Call function to process visits data
exec(open("Process_Visits.py").read())

#Process non longitudinal data
processNonLongitudinal(cohort_name)

#Process longitudinal data
processLongitudinal(cohort_name)

#Process visits data
processVisits(cohort_name)

