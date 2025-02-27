import math

def ramanujan_maximum(number: int):
    return math.ceil(4 * number * math.log(4 * number))

def initialise_prime_pi(limit: int):
    result = [1] * limit
    result[0] = 0
    result[1] = 0

    for i in range(4, limit, 2):
        result[i] = 0

    p = 3
    square = 9

    while square < limit:
        if result[p] != 0:
            q = square

            while q < limit:
                result[q] = 0
                q += p << 1

        square += (p + 1) << 2
        p += 2

    for i in range(1, len(result)):
        result[i] += result[i - 1]

    return result

def ramanujan_prime(prime_pi: list[int], number: int):
    maximum = ramanujan_maximum(number)

    if maximum & 1 == 1:
        maximum -= 1

    index = maximum

    while prime_pi[index] - prime_pi[index // 2] >= number:
        index -= 1

    return index + 1

def list_primes_less_than(limit: int):
    composite = [False] * limit
    n = 3
    n_squared = 9

    while n_squared <= limit:
        if not composite[n]:
            k = n_squared

            while k < limit:
                composite[k] = True
                k += 2 * n

        n_squared += (n + 1) << 2
        n += 2

    result = [2]

    for i in range(3, limit, 2):
        if not composite[i]:
            result.append(i)

    return result

def main():
    limit = 1_000_000
    prime_pi = initialise_prime_pi(ramanujan_maximum(limit) + 1)
    millionth_ramanujan_prime = ramanujan_prime(prime_pi, limit)
    print("The 1_000_000th Ramanujan prime is", millionth_ramanujan_prime)

    primes = list_primes_less_than(millionth_ramanujan_prime)
    ramanujan_prime_indexes = [0] * len(primes)

    for i in range(len(ramanujan_prime_indexes)):
        ramanujan_prime_indexes[i] = prime_pi[primes[i]] - prime_pi[primes[i] // 2]

    lower_limit = ramanujan_prime_indexes[len(ramanujan_prime_indexes) - 1]

    for i in range(len(ramanujan_prime_indexes) - 2, -1, -1):
        if ramanujan_prime_indexes[i] < lower_limit:
            lower_limit = ramanujan_prime_indexes[i]
        else:
            ramanujan_prime_indexes[i] = 0

    ramanujan_primes = []

    for i in range(len(ramanujan_prime_indexes)):
        if ramanujan_prime_indexes[i] != 0:
            ramanujan_primes.append(primes[i])

    twins_count = 0

    for i in range(len(ramanujan_primes) - 1):
        if ramanujan_primes[i] + 2 == ramanujan_primes[i + 1]:
            twins_count += 1

    print("There are", twins_count, "twins in the first", limit, "Ramanujan primes.")

if __name__ == '__main__':
    main()
