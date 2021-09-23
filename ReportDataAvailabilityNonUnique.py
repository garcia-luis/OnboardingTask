# This template demonstrates how to report data availability 
# from any cohort in cohort builder.

# Import packages
print("Import packages")
import neuroblu as nb
import pandas as pd
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
from functools import reduce

# neuroblu.get_cohort() function will allow you to get the patient IDs 
# stored within a particular Cohort Builder project.
# In this example, we are getting patient IDs stored within
# a Cohort Builder Project named 'Cohort For Onboarding Task'. 
print("Get desired cohort")
cohort_patients = nb.get_cohort('Cohort For Onboarding Task')

#Create list of variable names
names=['CGII','CGIS','Derived MADRS','Diagnosis','Drug','Family history','GAF',
       'MADRS','RSAV','SAV','Smooth CGIS','Visit','Stressors']

#Define availability function
def data_available (data_cohort):
  
  available = len(data_cohort['person_id'].unique()) 
  
  return available

#Define percentage function
def percentage_available (data_cohort, built_cohort):
  
  per_available = len(data_cohort['person_id'].unique()) / len(built_cohort) *100
  percentage = round(per_available, 2)
  
  return percentage

#Create empty lists to append values
available_ap = []
per_available_ap = []

#Use functions for all data of interest#
#List of specific parts of get functions in neuroblue to loop through
getlist = ['CGII', 'CGIS', 'derived_MADRS', 'diagnosis', 'drug', 'family_history',
          'GAF', 'MADRS', 'RSAV', 'SAV', 'smooth_CGIS', 'visit', 'stressors']

#START LOOP
for i in getlist:
  instruction = ["cohort=nb.get_%s(cohort_patients)"%(i)] #Generating instruction to define 'cohort'
  exec(instruction[0]) #Taking the instruction out of a list to execute it
  available_ap.append(data_available(cohort)) #Estimate available data
  per_available_ap.append(percentage_available(cohort, cohort_patients)) #Estimate percentage of available data
#END LOOP

#Create dataframe describing available data
df = pd.DataFrame() 
df['Variables'] = names
df['Available_data'] = available_ap
df['Percentage_available_data'] = per_available_ap

#Sort dataframe with available data in an asceding manner
df = df.sort_values(by=['Available_data'], ascending=True).reset_index(drop=True)

#Save dataframe with available data to csv
df.to_csv('Table_Available_Data_NonUnique.csv')

#Plot Data Available 
#Plot figure 
plt.figure(figsize=(7,7))
plt.barh(df['Variables'], df['Available_data']) 

#Plot and axis titles
plt.title('Available data')
plt.ylabel('Variables')
plt.xlabel('Number of patients')

#Customize frame
plt.gca().spines['right'].set_visible(False)
plt.gca().spines['top'].set_visible(False)

#Save plot
plt.savefig('Available_Data_NonLongitudinal.png')

#Plot Percentage of Data Available 
#Plot figure
plt.figure(figsize=(7,7))
plt.barh(df['Variables'], df['Percentage_available_data']) 

#Plot and axis titles
plt.title('Available data')
plt.ylabel('Variables')
plt.xlabel('Percentage of patients (%)')

#Customize frame
plt.gca().spines['right'].set_visible(False)
plt.gca().spines['top'].set_visible(False)

#Save plot
plt.savefig('Percentage_Available_Data_NonUnique.png')

