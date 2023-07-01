def binomialCoeff(n, k):
    result = 1
    for i in range(1, k+1):
        result = result * (n-i+1) // i
    return result

def pascal_upp(n):
    return [[binomialCoeff(j, i) for j in range(n)] for i in range(n)]

def pascal_low(n):
    return [[binomialCoeff(i, j) for j in range(n)] for i in range(n)]

def pascal_sym(n):
    return [[binomialCoeff(i+j, i) for j in range(n)] for i in range(n)]
