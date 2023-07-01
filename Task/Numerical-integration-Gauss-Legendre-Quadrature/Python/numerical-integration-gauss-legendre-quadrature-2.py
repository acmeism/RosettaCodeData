import numpy as np

# func is a function that takes a list-like input values
def gauss_legendre_integrate(func, domain, deg):
    x, w = np.polynomial.legendre.leggauss(deg)
    s = (domain[1] - domain[0])/2
    a = (domain[1] + domain[0])/2
    return np.sum(s*w*func(s*x + a))

for d in range(3, 10):
    print(d, gauss_legendre_integrate(np.exp, [-3, 3], d))
