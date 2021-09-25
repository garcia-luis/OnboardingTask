# This template demonstrates how to report data availability for longitudinal data
# from any cohort in cohort builder.

#Call functions from "Functions.py"
exec(open("Functions.py").read())

#Get and process longitudinal data
def processLongitudinal (cohort_name):
  # Get patient IDs stored within a Cohort Builder Project named 'Cohort For Onboarding Task'. 
  print("Get desired cohort from cohort builder")
  cohort_patients = nb.get_cohort(cohort_name)
  
  #Create list of variable names
  names=['CGII','CGIS','Derived MADRS','Diagnosis','Drug','Family history','GAF',
         'MADRS','RSAV','SAV','Smooth CGIS','Visit','Stressors']

  #Create empty lists to append values
  available_ap = []
  per_available_ap = []
  
  #START LOOP
  for i in getlist:
    print("Processing %s data"%(i))
    instruction = ["cohort=nb.get_%s(cohort_patients)"%(i)] #Generating instruction to define 'cohort'
    exec(instruction[0]) #Taking the instruction out of a list to execute it
    available_ap.append(data_available(cohort)) #Estimate available data and append it
    per_available_ap.append(percentage_available(cohort, cohort_patients)) #Estimate percentage of available data and append it
   #END LOOP

  #Create dataframe describing available data
  print("Creating dataframe for longitudinal data")
  df = pd.DataFrame() 
  df['Variables'] = names
  df['Available_data'] = available_ap
  df['Percentage_available_data'] = per_available_ap

  #Sort dataframe with available data in an asceding manner
  df = df.sort_values(by=['Available_data'], ascending=True).reset_index(drop=True)

  #Save dataframe with available data as a .csv file
  csv_file_longitudinal = df.to_csv('Table_Available_Data_Longitudinal.csv')
  
  #Plot Data Available 
  print("Creating horizontal barplots")
  hbarplotsvalues_longitudinal(df)

  #Plot Percentage of Data Available 
  hbarplotspercentage_longitudinal(df)
  
  return csv_file_longitudinal

