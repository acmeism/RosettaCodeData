from __future__ import print_function
import re
class Item:
    def __init__(self, name, year, era):
        self.name = name
        self.year = int(year)
        self.era  = era
        if era == "BCE":
            self.year = -self.year

    def __lt__(self, other):
        return self.year < other.year

import sys
for tbl in sys.argv[1:]:
    with open(tbl) as file:
        lines = file.read().rstrip().split('\n')

    items = []
    for line in lines:
        spl = re.split(r'\s+', line.rstrip())
        name = ' '.join(spl[0:-2])
        year = spl[-2]
        era  = spl[-1]
        it   = Item(name, year, era)
        items.append(it)
    items.sort()
    maxlen = max(map(lambda x:len(x.name),items))
    for it in items:
        name = it.name.ljust(maxlen)
        year = str(abs(it.year)).ljust(4)
        era  = it.era.ljust(3)
        print(name,year,era)
    print()
