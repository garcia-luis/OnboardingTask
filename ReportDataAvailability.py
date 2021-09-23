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

#Get variables with unique values in the cohort and store them in a dataframe
print("Get data for variables of interest")
cohort_birth_year = nb.get_birth_year(cohort_patients) #Birth year
cohort_gender = nb.get_gender(cohort_patients) #Gender
cohort_city = nb.get_city(cohort_patients) #City
cohort_education_years = nb.get_education_years(cohort_patients) #Education years
cohort_employment = nb.get_employment(cohort_patients) #Employment
cohort_ethnicity = nb.get_ethnicity(cohort_patients) #Ethnicity
cohort_marital = nb.get_marital(cohort_patients) #Marital status
cohort_race = nb.get_race(cohort_patients) #Race
cohort_state = nb.get_state(cohort_patients) #State

#Create list of dataframes
all_dataframes = [cohort_birth_year, cohort_gender, cohort_city,
                  cohort_education_years, cohort_employment, cohort_ethnicity, 
                  cohort_marital, cohort_race, cohort_state]

#Merge multiple dataframes into one based on 'person_id'
data = reduce(lambda  left,right: pd.merge(left,right,on=['person_id'],
                                            how='outer'), all_dataframes)

#Remove 'person_id' column
data = data.drop(columns=['person_id'])

#Replace Unknown / UNKNOWN for Nans
data = data.replace('Unknown', np.nan)
data = data.replace('UNKNOWN', np.nan)

#Create dictionary with neat names for variables
names={'birth_year':'Year of birth',
      'gender':'Gender',
      'city':'City',
      'years_in_education':'Education years',
      'employment_status':'Employment status',
      'ethnicity':'Ethnicity',
      'marital_status':'Marital status',
      'race':'Race',
      'state':'State'}

#List of columns names in data
colnames = list(data.columns)

#Create table with available data
dct = {'Total_data':{}, 'Missing_data':{}, 'Available_data':{}, 'Percentage_available_data':{}, 'Proportion_available_data':{}}

for i in colnames:
  
  total = 0 #Set total to zero
  total = len(data['%s'%(i)]) #Estimate total data
  
  missing = 0 #Set missing data to zero
  missing = data['%s'%(i)].isnull().sum()
  
  available = 0 #Set available to zero
  available = total - missing #Estimate total available data
  
  per_available = 0 #Set per_available to zero 
  per_available = available / total *100
  
  proportion_available = 0 #Set proportion_available to zero
  proportion_available = available / total
  
  dct['Total_data'][names[(i)]] = '%i'%(total) #Add total data
  dct['Missing_data'][names[(i)]] = '%i'%(missing)
  dct['Available_data'][names[(i)]] = '%i'%(available)
  dct['Percentage_available_data'][names[(i)]] = '%.2f'%(per_available)
  dct['Proportion_available_data'][names[(i)]] = '%.4f'%(proportion_available)

#Transform dictionary into dataframe
df = pd.DataFrame(dct)

#Convert all columns of DataFrame to numeric
df = df.apply(pd.to_numeric)

#Sort df
df = df.sort_values(by=['Available_data'], ascending=True)

#Save df to csv
df.to_csv('Table_Available_Data_NonLongitudinal.csv')

#Plot Data Available 
#Plot figure 
plt.figure(figsize=(7,7))
plt.barh(df.index, df['Available_data']) 

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
plt.barh(df.index, df['Percentage_available_data']) 

#Plot and axis titles
plt.title('Available data')
plt.ylabel('Variables')
plt.xlabel('Percentage of patients (%)')

#Customize frame
plt.gca().spines['right'].set_visible(False)
plt.gca().spines['top'].set_visible(False)

#Save plot
plt.savefig('Percentage_Available_Data_NonLongitudinal.png')
