# pell_numbers.py by Xing216
def is_prime(n):
    if n == 1:
        return False
    i = 2
    while i*i <= n:
        if n % i == 0:
            return False
        i += 1
    return True
def pell(p0: int,p1: int,its: int):
    nums = [p0,p1]
    primes = {}
    idx = 2
    while len(nums) != its:
        p = 2*nums[-1]+nums[-2]
        if is_prime(p):
           primes[idx] = p
        nums.append(p)
        idx += 1
    return nums, primes
def nsw(its: int,pell_nos: list):
    nums = []
    for i in range(its):
        nums.append(pell_nos[2*i] + pell_nos[2*i+1])
    return nums
def pt(its: int, pell_nos: list):
    nums = []
    for i in range(1,its+1):
        hypot = pell_nos[2*i+1]
        shorter_leg = sum(pell_nos[:2*i+1])
        longer_leg = shorter_leg + 1
        nums.append((shorter_leg,longer_leg,hypot))
    return nums
pell_nos, pell_primes = pell(0,1,50)
pell_lucas_nos, pl_primes = pell(2,2,10)
nsw_nos = nsw(10, pell_nos)
pythag_triples = pt(10, pell_nos)
sqrt2_approx = {}
for idx, pell_no in enumerate(pell_nos):
    numer = pell_nos[idx-1] + pell_no
    if pell_no != 0:
        sqrt2_approx[f"{numer}/{pell_no}"] = numer/pell_no
print(f"The first 10 Pell Numbers:\n {' '.join([str(_) for _ in pell_nos[:10]])}")
print(f"The first 10 Pell-Lucas Numbers:\n {' '.join([str(_) for _ in pell_lucas_nos])}")
print(f"The first 10 rational and decimal approximations of sqrt(2) ({(2**0.5):.10f}):")
print("  rational | decimal")
for rational in list(sqrt2_approx.keys())[:10]:
    print(f"{rational:>10} ≈ {sqrt2_approx[rational]:.10f}")
print("The first 7 Pell Primes:")
print(" index | Pell Prime")
for idx, prime in pell_primes.items():
    print(f"{idx:>6} | {prime}")
print(f"The first 10 Newman-Shank-Williams numbers:\n {' '.join([str(_) for _ in nsw_nos])}")
print(f"The first 10 near isosceles right triangles:")
for i in pythag_triples:
    print(f" {i}")
