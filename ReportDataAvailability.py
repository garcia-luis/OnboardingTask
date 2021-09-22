# This template demonstrates how to report data availability 
# from any cohort in cohort builder.

# Import packages
print("Import packages")
import neuroblu as nb

# neuroblu.list_available_cohorts() function will list cohort builder projects 
# that are linked to current dataset and are available for importing.
# If there is no existing cohort, go to the Cohort Builder to create a new cohort.
print("List all cohorts linked to this dataset")
nb.list_available_cohorts()

# neuroblu.get_cohort() function will allow you to get the patient IDs 
# stored within a particular Cohort Builder project.
# In this example, we are getting patient IDs stored within
# a Cohort Builder Project named 'Female PTSD Patients prescribed with Sertraline'. 
print("Get desired cohort")
cohort_patients = nb.get_cohort('Cohort For Onboarding Task') 

# Get gender for the cohort
cohort_gender = nb.get_gender(cohort_patients)
cohort_gender.head()
