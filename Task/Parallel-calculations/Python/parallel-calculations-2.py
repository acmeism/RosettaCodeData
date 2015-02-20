import multiprocessing

# ========== #Python3 - concurrent
from math import floor, sqrt

numbers = [
    112272537195293,
    112582718962171,
    112272537095293,
    115280098190773,
    115797840077099,
    1099726829285419]
# numbers = [33, 44, 55, 275]

def lowest_factor(n, _start=3):
    if n % 2 == 0:
        return 2
    search_max = int(floor(sqrt(n))) + 1
    for i in range(_start, search_max, 2):
        if n % i == 0:
            return i
    return n

def prime_factors(n, lowest):
    pf = []
    while n > 1:
        pf.append(lowest)
        n //= lowest
        lowest = lowest_factor(n, max(lowest, 3))
    return pf
# ========== #Python3 - concurrent

def prime_factors_of_number_with_lowest_prime_factor(numbers):
    pool = multiprocessing.Pool(processes=5)
    factors = pool.map(lowest_factor,numbers)

    low_factor,number = max((l,f) for l,f in zip(factors,numbers))
    all_factors = prime_factors(number,low_factor)
    return number,all_factors

if __name__ == '__main__':
    print('For these numbers:')
    print('\n  '.join(str(p) for p in numbers))
    number, all_factors = prime_factors_of_number_with_lowest_prime_factor(numbers)
    print('    The one with the largest minimum prime factor is {}:'.format(number))
    print('      All its prime factors in order are: {}'.format(all_factors))
