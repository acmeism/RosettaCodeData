#!/bin/python3
from itertools import zip_longest

# This is wrong, it works only on specific examples
def beadsort(l):
    return list(map(sum, zip_longest(*[[1] * e for e in l], fillvalue=0)))


# Demonstration code:
print(beadsort([5,3,1,7,4,1,1]))
