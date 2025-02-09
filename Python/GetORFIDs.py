
from Bio import SeqIO

# Input and Output
input_fasta = "GC_250.fna"
output_ids = "ORF_IDs.txt"

# Extract IDs from ORF and save them
with open(output_ids, "w") as f:
    for record in SeqIO.parse(input_fasta, "fasta"):
        f.write(record.id + "\n")