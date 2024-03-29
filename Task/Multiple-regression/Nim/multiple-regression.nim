# Using Wikipedia data sample.

import math
import arraymancer, sequtils

var

  height = [1.47, 1.50, 1.52, 1.55, 1.57, 1.60, 1.63, 1.65,
            1.68, 1.70, 1.73, 1.75, 1.78, 1.80, 1.83].toTensor()

  weight = [52.21, 53.12, 54.48, 55.84, 57.20, 58.57, 59.93, 61.29,
            63.11, 64.47, 66.28, 68.10, 69.92, 72.19, 74.46].toTensor()

# Create Vandermonde matrix.
var a = stack(height.ones_like, height, height *. height, axis = 1)

echo toSeq(least_squares_solver(a, weight).solution.items)
