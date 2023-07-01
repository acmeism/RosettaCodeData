x1 = 0
x2 = 0
quadratic(3, 4, 4/3.0)  # [-2/3]
see "x1 = " + x1 + " x2 = " + x2 + nl
quadratic(3, 2, -1)      # [1/3, -1]
see "x1 = " + x1 + " x2 = " + x2 + nl
quadratic(-2,  7, 15)    # [-3/2, 5]
see "x1 = " + x1 + " x2 = " + x2 + nl
quadratic(1, -2,  1)     # [1]
see "x1 = " + x1 + " x2 = " + x2 + nl

func quadratic a, b, c
     sqrtDiscriminant = sqrt(pow(b,2) - 4*a*c)
     x1 = (-b + sqrtDiscriminant) / (2.0*a)
     x2 = (-b - sqrtDiscriminant) / (2.0*a)
     return [x1, x2]
