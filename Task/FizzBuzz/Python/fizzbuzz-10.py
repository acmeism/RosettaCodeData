'''Fizz buzz'''

from itertools import count, cycle, islice


# fizzBuzz :: () -> Generator [String]
def fizzBuzz():
    '''A non-finite stream of fizzbuzz terms.
    '''
    return map(
        lambda f, b, n: (f + b) or str(n),
        cycle([''] * 2 + ['Fizz']),
        cycle([''] * 4 + ['Buzz']),
        count(1)
    )


# ------------------------- TEST -------------------------
def main():
    '''Display of first 100 terms of the fizzbuzz series.
    '''
    print(
        '\n'.join(
            list(islice(
                fizzBuzz(),
                100
            ))
        )
    )


if __name__ == '__main__':
    main()
