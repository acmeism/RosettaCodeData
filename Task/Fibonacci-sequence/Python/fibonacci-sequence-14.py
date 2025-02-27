'''Fibonacci accumulation'''

from itertools import accumulate

# fibs :: Integer :: [Integer]
def fibs(n):
    '''An accumulation of the first n integers in
       the Fibonacci series. The accumulator is a
       pair of the two preceding numbers.
    '''
    return [
        a
        for a, b in accumulate(
            range(1, n),  # we don't actually use these numbers
            lambda acc, _: (acc[1],  sum(acc)),
            initial = (0, 1)
        )
    ]


# MAIN ---
if __name__ == '__main__':
    print(f'First twenty: {fibs(20)}')
