# This template demonstrates how to report data availability for non-longitudinal data
# from any cohort in cohort builder.

#Call functions from "Functions.py"
exec(open("Functions.py").read())

def processNonLongitudinal (cohort_name):
  # Get patient IDs stored within a Cohort Builder Project named 'Cohort For Onboarding Task'. 
  print("Get desired cohort from cohort builder")
  cohort_patients = nb.get_cohort(cohort_name) 

  #Get variables with unique values in the cohort and store them in a dataframe
  print("Get data for non longitudinal variables of interest")
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
  dct = {'Total_data':{}, 'Missing_data':{}, 'Available_data':{}, 
         'Percentage_available_data':{}, 'Proportion_available_data':{}}

  for i in colnames:
    print("Processing %s data"%(i))
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
    #Fill dictionary with calculations
    dct['Total_data'][names[(i)]] = '%i'%(total)
    dct['Missing_data'][names[(i)]] = '%i'%(missing)
    dct['Available_data'][names[(i)]] = '%i'%(available)
    dct['Percentage_available_data'][names[(i)]] = '%.2f'%(per_available)
    dct['Proportion_available_data'][names[(i)]] = '%.4f'%(proportion_available)

  #Transform dictionary into dataframe
  print("Creating dataframe for non-longitudinal data")
  df = pd.DataFrame(dct)
  
  #Convert all columns of DataFrame to numeric
  df = df.apply(pd.to_numeric)
  
  #Change index to a column in df
  df['Variables'] = df.index
  
  #Sort df
  df = df.sort_values(by=['Available_data'], ascending=True).reset_index(drop=True)
  
  #Save df to csv
  csv_file_nonlongitudinal = df.to_csv('Table_Available_Data_NonLongitudinal.csv')
  
  #Plot Data Available 
  print("Creating horizontal barplots")
  hbarplotsvalues_nonlongitudinal(df)
  
  #Plot Percentage of Data Available 
  hbarplotspercentage_nonlongitudinal(df)
  
  return csv_file_nonlongitudinal

