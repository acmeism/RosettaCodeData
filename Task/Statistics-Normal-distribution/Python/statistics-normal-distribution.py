from __future__ import division
import matplotlib.pyplot as plt
import random

mean, stddev, size = 50, 4, 100000
data = [random.gauss(mean, stddev) for c in range(size)]

mn = sum(data) / size
sd = (sum(x*x for x in data) / size
      - (sum(data) / size) ** 2) ** 0.5

print("Sample mean = %g; Stddev = %g; max = %g; min = %g for %i values"
      % (mn, sd, max(data), min(data), size))

plt.hist(data,bins=50)
