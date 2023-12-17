# home_primes.py by Xing216
def primeFactors(n: int) -> list[int]:
    primeFactorsL = []
    while n % 2 == 0:
        primeFactorsL.append(2)
        n = n // 2
    for i in range(3,int(n**0.5)+1,2):
        while n % i== 0:
            primeFactorsL.append(i)
            n = n // i
    if n > 2:
        primeFactorsL.append(n)
    return primeFactorsL
def list_to_int(l: list[int]) -> int:
    return int(''.join(str(i) for i in l))
def home_prime_chain(i:int) -> list[int]:
    pf_int = i
    chain = []
    while True:
        pf = primeFactors(pf_int)
        pf_int = list_to_int(pf)
        if len(pf) == 1:
            return chain
        else:
            chain.append(pf_int)
for i in range(2,21):
    chain_list = home_prime_chain(i)
    chain_len = len(chain_list)
    chain_idx_list = list(range(chain_len))[::-1]
    j = chain_len
    if chain_list != []:
        print(f"HP{i}({chain_len}) =", end=" ")
        for k,l in list(zip(chain_list, chain_idx_list)):
            if l == 0:
                print(f"{k}")
            else:
                print(f"HP{k}({l}) =", end=" ")
    else:
        print(f"HP{i}(1) = {i}")
