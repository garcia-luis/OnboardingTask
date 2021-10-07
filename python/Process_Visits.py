# This template demonstrates how to report data availability for visits data
# from any cohort in cohort builder.

# Call functions from "Functions.py"
exec(open("Functions_Visits.py").read())

# Get and process visits data
def processVisits (cohort_name):
  # Get information for types of visits
  print("Get desired visits")
  visits_data = queryVisits(cohort_name, type_of_visits)
  
  # Create empty lists to append values
  per_available_ap = []
  names_visits = []
  
  # START LOOP
  for i in type_of_visits:
    print("Processing %s data"%(i))
    tmp = visits_data.loc[visits_data['concept_name'] == '%s'%(i)] # Create subset dataframe for one type of visit
    per_available_ap.append(visits_percentage_available(tmp, visits_data)) # Estimate percentage of data available
    names_visits.append(i) #Append names of types of visits
  # END LOOP
  
  # Create dataframe describing available data
  print("Creating dataframe for visits data")
  df_visits = pd.DataFrame() 
  df_visits['Variables'] = names_visits
  df_visits['Percentage_available_data'] = per_available_ap
  
  # Sort dataframe with available data in an asceding manner
  df_visits = df_visits.sort_values(by=['Percentage_available_data'], ascending=True).reset_index(drop=True)

  #Rename Percentage_available_data column for csv file which is created below
  df_nice_names = df_visits.rename(columns={'Percentage_available_data': 'Percentage available (%)'})
  
  # Save dataframe with available data for visits as a .csv file
  csv_file_visits = df_nice_names.to_csv('Table_Available_Data_Visits.csv')

  # Plot Percentage of Data Available for visits
  print("Creating horizontal barplot for types of visits")
  hbarplotspercentage_visits(df_visits)
  
  return csv_file_visits
