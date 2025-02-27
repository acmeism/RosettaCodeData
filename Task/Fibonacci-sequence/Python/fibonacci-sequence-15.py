'''Nth Fibonacci term (by folding)'''

from functools import reduce

# nthFib :: Integer -> Integer
def nthFib(n):
    '''Nth integer in the Fibonacci series.'''
    return reduce(
        lambda acc, _: (acc[1], sum(acc)),
        range(1, n),
        (0, 1)
    )[0]


# MAIN ---
if __name__ == '__main__':
    n = 1000
    print(f'{n}th term: {nthFib(n)}')
