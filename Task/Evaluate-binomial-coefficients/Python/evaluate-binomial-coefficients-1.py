def binomialCoeff(n, k):
    result = 1
    for i in range(1, k+1):
        result = result * (n-i+1) / i
    return result

if __name__ == "__main__":
    print(binomialCoeff(5, 3))
