# useful.py by xing216
from gmpy2 import is_prime
def useful(n):
    k = 1
    is_useful = False
    while is_useful == False:
        if is_prime(2**(2**n) - k):
            is_useful = True
            break
        k += 2
    return k
if __name__ == "__main__":
    print("n | k")
    for i in range(1,14):
        print(f"{i:<4}{useful(i)}")
