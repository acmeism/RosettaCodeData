from __future__ import division
import math
import sys

def fivenum(array):
    n = len(array)
    if n == 0:
        print("you entered an empty array.")
        sys.exit()
    x = sorted(array)

    n4 = math.floor((n+3.0)/2.0)/2.0
    d = [1, n4, (n+1)/2, n+1-n4, n]
    sum_array = []

    for e in range(5):
        floor = int(math.floor(d[e] - 1))
        ceil = int(math.ceil(d[e] - 1))
        sum_array.append(0.5 * (x[floor] + x[ceil]))

    return sum_array

x = [0.14082834, 0.09748790, 1.73131507, 0.87636009, -1.95059594, 0.73438555, -0.03035726, 1.46675970,
-0.74621349, -0.72588772, 0.63905160, 0.61501527, -0.98983780, -1.00447874, -0.62759469, 0.66206163,
1.04312009, -0.10305385, 0.75775634, 0.32566578]

y = fivenum(x)
print(y)
