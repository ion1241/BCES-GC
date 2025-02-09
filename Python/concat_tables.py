import os
import csv
import pandas as pd
import glob

# Find all files matching the pattern
file_pattern = "13.*.txt"
files = glob.glob(file_pattern)

# Read each file into a DataFrame and store them in a list
dataframes = [pd.read_table(file) for file in files]

# Concatenate all DataFrames
concat_ORFdata = pd.concat(dataframes)

# Save the concatenated DataFrame to a CSV file
concat_ORFdata.to_csv("ORF_dataAll.csv", index=False, quoting=csv.QUOTE_NONE, quotechar="", escapechar="\t")

