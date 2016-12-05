import math, sequtils

echo sum(map(@[1,2,3,4,5], proc (x: int): int = x*x))
