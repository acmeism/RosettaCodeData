import math

for (a, b) in [(21, 15), (17, 23), (36, 12), (18, 29), (60, 15)]:
  echo a, " and ", b, " are ", if gcd(a, b) == 1: "coprimes." else: "not coprimes."
