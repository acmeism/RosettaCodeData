import random
from collections import defaultdict

printdead, printlive = '-#'
maxgenerations = 3
cellcount = 3,3
celltable = defaultdict(int, {
 (1, 2): 1,
 (1, 3): 1,
 (0, 3): 1,
 } ) # Only need to populate with the keys leading to life

##
## Start States
##
# blinker
u = universe = defaultdict(int)
u[(1,0)], u[(1,1)], u[(1,2)] = 1,1,1

## toad
#u = universe = defaultdict(int)
#u[(5,5)], u[(5,6)], u[(5,7)] = 1,1,1
#u[(6,6)], u[(6,7)], u[(6,8)] = 1,1,1

## glider
#u = universe = defaultdict(int)
#maxgenerations = 16
#u[(5,5)], u[(5,6)], u[(5,7)] = 1,1,1
#u[(6,5)] = 1
#u[(7,6)] = 1

## random start
#universe = defaultdict(int,
#                       # array of random start values
#                       ( ((row, col), random.choice((0,1)))
#                         for col in range(cellcount[0])
#                         for row in range(cellcount[1])
#                       ) )  # returns 0 for out of bounds

for i in range(maxgenerations):
    print("\nGeneration %3i:" % ( i, ))
    for row in range(cellcount[1]):
        print("  ", ''.join(str(universe[(row,col)])
                            for col in range(cellcount[0])).replace(
                                '0', printdead).replace('1', printlive))
    nextgeneration = defaultdict(int)
    for row in range(cellcount[1]):
        for col in range(cellcount[0]):
            nextgeneration[(row,col)] = celltable[
                ( universe[(row,col)],
                  -universe[(row,col)] + sum(universe[(r,c)]
                                             for r in range(row-1,row+2)
                                             for c in range(col-1, col+2) )
                ) ]
    universe = nextgeneration
