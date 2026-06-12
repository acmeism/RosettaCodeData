#Aamrun, 4th October 2021

import sys

if len(sys.argv)!=2:
    print("Usage : python " + sys.argv[0] + " <filename>")
    exit()

dataFile = open(sys.argv[1],"r")

fileData = dataFile.read().split('\n')

dataFile.close()

[print(i) for i in fileData[::-1]]
