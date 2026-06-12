from __future__ import print_function
import sys, os
with open(sys.argv[1],"r") as file:
    table = file.readlines()

if table[-1][-1] != '\n':
    table[-1] += '\n'

import re
# Pass 1
years = []
for i in table:
    d = re.search(r"(\d+)\s+([A-Z]+)$", i)
    yr = int(d.group(1))
    if d.group(2) == "BCE":
        yr = -yr
    years.append(yr)

# Pass 2
yr_table = list(zip(years, table))
yr_table.sort(key=lambda x:x[0])

c = 1
for _, orig in yr_table:
    if c == len(yr_table):
        orig = orig.rstrip('\n')
    print(end=orig)
    c += 1
