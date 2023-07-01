def is_prime(n: int) -> bool:
    if n <= 3:
        return n > 1
    if n % 2 == 0 or n % 3 == 0:
        return False
    i = 5
    while i ** 2 <= n:
        if n % i == 0 or n % (i + 2) == 0:
            return False
        i += 6
    return True

def digit_sum(n: int) -> int:
    sum = 0
    while n > 0:
        sum += n % 10
        n //= 10
    return sum

def main() -> None:
    additive_primes = 0
    for i in range(2, 500):
        if is_prime(i) and is_prime(digit_sum(i)):
            additive_primes += 1
            print(i, end=" ")
    print(f"\nFound {additive_primes} additive primes less than 500")

if __name__ == "__main__":
    main()
