"""

Runs one test of the solver passing a
start and goal position.

"""

from astar import *
import time

# Rosetta Code start position


start_tiles =    [[ 15, 14,  1,  6],
                  [ 9, 11,  4, 12],
                  [ 0, 10,  7,  3],
                  [13,  8,  5,  2]]

goal_tiles =        [[ 1,  2,  3,  4],
                     [ 5,  6,  7,  8],
                     [ 9, 10, 11, 12],
                     [13, 14, 15,  0]]


before = time.perf_counter()

result = a_star(start_tiles,goal_tiles)

after = time.perf_counter()

print(" ")
print("Path length = "+str(len(result) - 1))
print(" ")
print("Path using rlud:")
print(" ")
print(path_as_0_moves(result))
print(" ")
print("Run time in seconds: "+str(after - before))
