def polynomial_derivative(list_coeff):
    derivative = []
    for i, val in enumerate(list_coeff):
        derivative.append(i*val)
    return derivative[1:]

test_polys = [[5],[4,-3],[-1,6,5],[-4,3,-2,1],[1,1,0,-1,-1]]
list(map(polynomial_derivative, test_polys))
