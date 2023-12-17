# int_radicals.py by Xing216

def radical(n):
    product = 1
    if (n % 2 == 0):
        product *= 2
        while (n%2 == 0):
            n = n/2
    for i in range (3, int((n)**0.5), 2):
        if (n % i == 0):
            product = product * i
            while (n%i == 0):
                n = n/i
    if (n > 2):
        product = product * n
    return int(product)
def distinctPrimeFactors(N):
    factors = []
    if (N < 2):
        factors.append(-1)
        return factors
    if N == 2:
      factors.append(2)
      return factors
    visited = {}
    i = 2
    while(i * i <= N):
        while(N % i == 0):
            if(i not in visited):
                factors.append(i)
                visited[i] = 1
            N //= i
        i+=1
    if(N > 2):
        factors.append(N)
    return factors
if __name__ == "__main__":
    print("Radical of first 50 positive integers:")
    for i in range(1,51):
        print(f"{radical(i):>2}", end=" ")
        if (i % 10 == 0):
            print()
    print()
    for n in [99999, 499999, 999999]:
        print(f"Radical of {n:>6}: {radical(n)}")
    distDict = {1:0,2:0,3:0,4:0,5:0,6:0,7:0}
    for i in range(1,1000000):
        distinctPrimeFactorCount = len(distinctPrimeFactors(i))
        distDict[distinctPrimeFactorCount] += 1
    print("\nDistribution of the first one million positive integers by numbers of distinct prime factors:")
    for key, value in distDict.items():
        print(f"{key}: {value:>6}")
    print("\nNumber of primes and powers of primes less than or equal to one million:")
    print(distDict[1])
