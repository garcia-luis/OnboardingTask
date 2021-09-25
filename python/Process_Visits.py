# This template demonstrates how to report data availability for visits data
# from any cohort in cohort builder.

#Call functions from "Functions.py"
exec(open("Functions_Visits.py").read())

#Get and process visits data
def processVisits (cohort_name):
  #Get information for types of visits
  print("Get desired visits")
  visits_data = queryVisits(cohort_name, type_of_visits)
  
  #Create empty lists to append values
  available_ap = []
  per_available_ap = []
  names_visits = []
  
  #START LOOP
  for i in type_of_visits:
    print("Processing %s data"%(i))
    tmp = visits_data.loc[visits_data['concept_name'] == '%s'%(i)] #Create subset dataframe for one type of visit
    available_ap.append(visits_available(tmp)) #Estimate available data for subset dataframe
    per_available_ap.append(visits_percentage_available(tmp, visits_data)) #Estimate percentage of data available
    names_visits.append(i) #Append names of types of visits
  #END LOOP
  
  #Create dataframe describing available data
  print("Creating dataframe for visits data")
  df_visits = pd.DataFrame() 
  df_visits['Variables'] = names_visits
  df_visits['Available_data'] = available_ap
  df_visits['Percentage_available_data'] = per_available_ap
  
  #Sort dataframe with available data in an asceding manner
  df_visits = df_visits.sort_values(by=['Available_data'], ascending=True).reset_index(drop=True)

  #Save dataframe with available data for visits as a .csv file
  csv_file_visits = df_visits.to_csv('Table_Available_Data_Visits.csv')
  
  #Plot Data Available for visits
  print("Creating horizontal barplot")
  hbarplotsvalues_visits(df_visits)

  #Plot Percentage of Data Available for visits
  print("Creating horizontal barplot with percentages")
  hbarplotspercentage_visits(df_visits)
  
  return csv_file_visits

