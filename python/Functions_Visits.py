#This template shows the functions used in the Process_Visits.py file

# Import packages
print("Import packages")
import neuroblu as nb
import pandas as pd
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
from functools import reduce
from textwrap import wrap

# Define visitis availability function
print("Create visits_available function")
def visits_available (data_cohort):
  
  available = len(data_cohort['visit_occurrence_id'].unique()) 
  
  return available

# Define visits percentage function
print("Create visits_percentage_available function")
def visits_percentage_available (data_cohort, built_cohort):
  
  per_available = len(data_cohort['visit_occurrence_id'].unique()) / len(built_cohort) *100
  percentage = round(per_available, 2)
  
  return percentage

# Define queryVisits function
def queryVisits (data, type_of_visits):
  print("Create queryVisits function")
  
  # Get data from cohort builder
  print("Get desired cohort from cohort builder")
  cohort_patients = nb.get_cohort(data)
  
  # Generate SQL instruction
  instruction = """SELECT vo.person_id, vo.visit_occurrence_id, c.concept_id, c.concept_name
              FROM visit_occurrence vo
              JOIN concept c ON vo.visit_concept_id = c.concept_id
             WHERE vo.person_id IN (?values)"""
  print("Instruction generated")
  
  # Fill SQL instruction with a single element string
  query = instruction.replace('?values', ','.join(str(item) for item in cohort_patients))
  print("Query generated")
  
  # Create dataframe with the data from the instruction
  final_query = nb.get_query(query)
  
  # Filter for type_of_visits:
  print("Filtering for types of visits")
  if len(type_of_visits) != 0:
    final_query = final_query[final_query['concept_name'].isin(type_of_visits)]
  else:
  	final_query = final_query
    
  return final_query
  
# Define horizontal barplot function using values for Visits data
print("Create hbarplotspercentage_visits function")
def hbarplotspercentage_visits (data):
  # Label wrap
  labels = data['Variables']
  labels = [ '\n'.join(wrap(l, 20)) for l in labels ]
  # Figure
  plt.figure(figsize=(7,7))
  plt.barh(data['Variables'], data['Percentage_available_data'], color = "royalblue",
          tick_label = labels) 
  # Plot and axis titles
  plt.title('Available data')
  plt.ylabel('Visits')
  plt.xlabel('Percentage of visits (%)')
  # Customize frame
  plt.gca().spines['right'].set_visible(False)
  plt.gca().spines['top'].set_visible(False)
  # Save plot
  plotfigure = plt.savefig('Percentage_Available_Data_Visits.png')
  
  return plotfigure
