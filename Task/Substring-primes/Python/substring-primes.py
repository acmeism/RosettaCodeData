import math

def is_prime(n: int):
    if n <= 1:
        return False

    for i in range(2, int(math.sqrt(n)) + 1):
        if n % i == 0:
            return False

    return True

def main():
    primes = []

    for i in range(2, 500):
        if i < 10:
            if is_prime(i):
                primes.append(i)
        else:
            prime_check = True
            num_str = str(i)

            for ii in range(len(num_str)):
                for j in range(ii+1, len(num_str)+1):
                    if not is_prime(int(num_str[ii:j])):
                        prime_check = False
                        break

                if not prime_check:
                    break
            else:
                primes.append(i)

    print("Found %d primes < 500 where all substrings are also primes, namely:" % len(primes))
    print(primes)

if __name__ == '__main__':
    main()
