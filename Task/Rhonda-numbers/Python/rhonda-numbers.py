# rhonda.py by Xing216
def prime_factors_sum(n):
    i = 2
    factors_sum = 0
    while i * i <= n:
        if n % i:
            i += 1
        else:
            n //= i
            factors_sum+=i
    if n > 1:
        factors_sum+=n
    return factors_sum
def digits_product(n: int, base: int):
    # translated from the nim solution
    i = 1
    while n != 0:
        i *= n % base
        n //= base
    return i
def is_rhonda_num(n:int, base: int):
    product = digits_product(n, base)
    return product == base * prime_factors_sum(n)
def convert_base(num,b):
    numerals="0123456789abcdefghijklmnopqrstuvwxyz"
    return ((num == 0) and numerals[0]) or (convert_base(num // b, b).lstrip(numerals[0]) + numerals[num % b])
def is_prime(n):
    if n == 1:
        return False
    i = 2
    while i*i <= n:
        if n % i == 0:
            return False
        i += 1
    return True
for base in range(4,37):
    rhonda_nums = []
    if is_prime(base):
        continue
    i = 1
    while len(rhonda_nums) < 10:
        if is_rhonda_num(i,base) :
            rhonda_nums.append(i)
            i+=1
        else:
            i+=1
    print(f"base {base}: {', '.join([convert_base(n, base) for n in rhonda_nums])}")
