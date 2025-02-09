import pandas
import os
import csv

#Read ORF data file
ORFInfo=pandas.read_csv("ORF_dataAll.csv")
#Get the headers
headers=pandas.read_table("ORF_IDs.txt",  names=["ORF ID"])
#Merge the two to have proper ORF names with all the info
Filteredtable= pandas.merge(headers,ORFInfo, on="ORF ID", how="inner")
#Write the file
Filteredtable.to_csv("ORF_datafiltered.csv", index=False, quoting=csv.QUOTE_NONE, quotechar="",  escapechar=",")
