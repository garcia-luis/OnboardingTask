# This template demonstrates how to report data availability for longitudinal data
# from any cohort in cohort builder.

# Call functions from "Functions.py"
exec(open("Functions.py").read())

# Get and process longitudinal data
def processLongitudinal (cohort_name):
  # Get patient IDs stored within a Cohort Builder Project named 'Cohort For Onboarding Task'. 
  print("Get desired cohort from cohort builder")
  cohort_patients = nb.get_cohort(cohort_name)
  # Get total number of patients
  total = len(cohort_patients)
  
  # Create list of variable names
  names=['CGIS','Diagnosis','Drug','Family history','GAF','MADRS',
         'MSE','Stressors']
  
  # Create list that includes parts of NeuroBlu functions to use in the for loop below
  getlist = ['CGIS', 'diagnosis', 'drug', 'family_history','GAF','MADRS',
             'SAV','stressors']

  # Create empty lists to append values
  per_available_ap = []
  
  # START LOOP
  for i in getlist:
    print("Processing %s data"%(i))
    # Generating instruction to define 'cohort'
    instruction = ["nb.get_%s(cohort_patients)"%(i)]
    # Taking the instruction out of a list to evaluate it
    cohort = eval(instruction[0])
    # Estimate percentage of available data
    cohort_percentage = percentage_available(cohort, cohort_patients)
    # Append percentage of available data
    per_available_ap.append(cohort_percentage)
   # END LOOP

  # Create dataframe describing available data
  print("Creating dataframe for longitudinal data")
  df = pd.DataFrame() 
  df['Variables'] = names
  df['Percentage_available_data'] = per_available_ap

  # Sort dataframe with available data in an asceding manner
  df = df.sort_values(by=['Percentage_available_data'], ascending=True).reset_index(drop=True)
  
  # Rename Percentage_available_data column for csv file which is created below
  df_nice_names = df.rename(columns={'Percentage_available_data': 'Percentage available (%)'})
  
  # Save dataframe with available data as a .csv file
  print("Percentages were estimated according to the total number of patients, which equals %d"%(total))
  csv_file_longitudinal = df_nice_names.to_csv('Table_Available_Data_Longitudinal.csv')

  # Plot Percentage of Data Available 
  print("Creating horizontal barplot for longitudinal data")
  hbarplotspercentage_longitudinal(df)
  
  return csv_file_longitudinal
