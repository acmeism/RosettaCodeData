# /**************************************************
# Subject: Computation of Euler's constant 0.5772...
#          with Euler's Zeta Series.
# tested : Python 3.11
# -------------------------------------------------*/

from scipy import special as s

def eulers_constant(n):
    k = 2
    euler = 0
    while k <= n:
        euler += (s.zeta(k) - 1)/k
        k += 1
    return 1 - euler

print(eulers_constant(47))
