from numpy import sqrt
from math import isclose

testvalues = [[100000000000000.01,           100000000000000.011],
              [100.01,                       100.011],
              [10000000000000.001 / 10000.0, 1000000000.0000001000],
              [0.001,                        0.0010000001],
              [0.000000000000000000000101,   0.0],
              [sqrt(2) * sqrt(2),            2.0],
              [-sqrt(2) * sqrt(2),          -2.0],
              [3.14159265358979323846,       3.14159265358979324]]

for (x, y) in testvalues:
    maybenot = "is" if isclose(x, y) else "is NOT"
    print(x, maybenot, "approximately equal to ", y)
