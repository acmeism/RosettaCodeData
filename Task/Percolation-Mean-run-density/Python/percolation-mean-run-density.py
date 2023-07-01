from __future__ import division
from random import random
from math import fsum

n, p, t = 100, 0.5, 500

def newv(n, p):
    return [int(random() < p) for i in range(n)]

def runs(v):
    return sum((a & ~b) for a, b in zip(v, v[1:] + [0]))

def mean_run_density(n, p):
    return runs(newv(n, p)) / n

for p10 in range(1, 10, 2):
    p = p10 / 10
    limit = p * (1 - p)
    print('')
    for n2 in range(10, 16, 2):
        n = 2**n2
        sim = fsum(mean_run_density(n, p) for i in range(t)) / t
        print('t=%3i p=%4.2f n=%5i p(1-p)=%5.3f sim=%5.3f delta=%3.1f%%'
              % (t, p, n, limit, sim, abs(sim - limit) / limit * 100 if limit else sim * 100))
