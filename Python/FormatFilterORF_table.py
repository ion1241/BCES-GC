#Remove Unused colums from KEGG data tables from SqueezeMeta to gain acces to the columns we need

import pandas
import sys


def main():
    file=sys.argv[1]
    df= pandas.read_table(file, skiprows=1, header=0, low_memory=False)
    dfmod=df.drop(df.columns[[1,2,3,6,10,11,12,13,14,15,16,17,18,19,20]], axis=1)
        
    print(dfmod.to_csv(sep="\t", index= False))

if __name__ == "__main__":

    main()
