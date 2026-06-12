from sympy import isprime, nextprime

def get_next_prime(n: int):
    if isprime(n):
        return n

    return nextprime(n)

def main():
    nums1 = [5,45,23,21,67]
    nums2 = [43,22,78,46,38]
    nums3 = [9,98,12,54,53]

    primes = [
        get_next_prime(max(x, y, z))
        for x, y, z in zip(nums1, nums2, nums3)
    ]

    print(primes)

if __name__ == '__main__':
    main()
