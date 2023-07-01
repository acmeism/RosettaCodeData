def count_in_factors(n):
    if is_prime(n) or n == 1:
        print(n,end="")
        return
    while n != 1:
        p = next_prime(1)
        while n % p != 0:
            p = next_prime(p)
        print(p,end="")
        n = n / p
        if n != 1: print(" x",end=" ")

for i in range(1, 101):
    print(i,"=",end=" ")
    count_in_factors(i)
    print("")
