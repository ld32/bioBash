#!/usr/bin/env python

import sys, getopt
from Bio import SeqIO

def main(argv):
    inputfile = ''
    outPrefix = ''
    try:
        opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
    except getopt.GetoptError:
        print ('splitConfigs.py -i <inputfile> -o <outPrefix>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print ('splitConfigs.py -i <inputfile> -o <outPrefix>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outPrefix = arg
    if inputfile == "" or outPrefix == "":
        print ('splitConfigs.py -i <inputfile> -o <outPrefix>')
        sys.exit(2)

    records = list(SeqIO.parse(inputfile, "fasta"))
    records.sort(key=lambda x: len(x.seq), reverse=True)

    size = len(records[0].seq)
    batch = []
    total = 0
    fileCount = 0
    for r in range(len(records)):
        batch.append(records[r])
        total += len(records[r].seq)
        if total >= size:
            SeqIO.write(batch, outPrefix + str(fileCount) + ".fasta", "fasta")
            batch = []
            total = 0 
            fileCount += 1

    if(len(batch)): 
        SeqIO.write(batch, outPrefix + str(fileCount) + ".fasta", "fasta")

if __name__ == "__main__":
   main(sys.argv[1:])