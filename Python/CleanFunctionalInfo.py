import pandas as pd

# Read the table
ORFTable = pd.read_csv("ORF_datafiltered.csv")

# Remove the asterisk from the KEGG and COG IDs
ORFTable['KEGG ID'] = ORFTable['KEGG ID'].str.replace('*', '', regex=False)
ORFTable['COG ID'] = ORFTable['COG ID'].str.replace('*', '', regex=False)

# If some columns have two or more values, separate them and remove the duplicated columns
ORFTable[['Gene', 'Backup']] = ORFTable['Gene name'].str.split(', ', expand=True, n=1)
ORFTable = ORFTable.drop(columns=['Gene name', 'Backup'])

ORFTable[['KEGG', 'Backup']] = ORFTable['KEGG ID'].str.split(';', expand=True, n=1)
ORFTable = ORFTable.drop(columns=['KEGG ID', 'Backup'])

ORFTable[['COG', 'Backup']] = ORFTable['COG ID'].str.split(';', expand=True, n=1)
ORFTable = ORFTable.drop(columns=['COG ID', 'Backup'])

ORFTable[['PFAM_C', 'Description']] = ORFTable['PFAM'].str.split(' ', expand=True, n=1)
ORFTable = ORFTable.drop(columns=['PFAM', 'Description'])

# Write the cleaned table to a new file
ORFTable.to_csv("ORF_InfoClean.txt", sep="\t", index=False, quoting=pd.io.common.csv.QUOTE_NONE)
