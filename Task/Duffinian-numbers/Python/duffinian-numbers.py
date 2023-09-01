# duffinian.py by xing216

def factors(n):
    factors = []
    for i in range(1, n + 1):
       if n % i == 0:
           factors.append(i)
    return factors
def gcd(a, b):
    while b != 0:
        a, b = b, a % b
    return a
is_relively_prime = lambda a, b: gcd(a, b) == 1
sigma_sum = lambda x: sum(factors(x))
is_duffinian = lambda x: is_relively_prime(x, sigma_sum(x)) and len(factors(x)) > 2
count = 0
i = 0
while count < 50:
    if is_duffinian(i):
        print(i, end=' ')
        count += 1
    i+=1
count2 = 0
j = 0
while count2 < 20:
    if is_duffinian(j) and is_duffinian(j+1) and is_duffinian(j+2):
        print(f"({j},{j+1},{j+2})", end=' ')
        count2 += 1
        j+=3
    j+=1
