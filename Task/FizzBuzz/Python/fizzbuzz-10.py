'''Fizz buzz'''

from itertools import count, cycle, islice


# fizzBuzz :: () -> Generator [String]
def fizzBuzz():
    '''A non-finite stream of fizzbuzz terms.'''
    return map(
        lambda f, b, n: (f + b) or n,
        cycle([''] * 2 + ['Fizz']),
        cycle([''] * 4 + ['Buzz']),
        map(str, count(1))
    )


# main :: IO ()
def main():
    '''Display of first 100 terms of the fizzbuzz series.
    '''
    print(unlines(
        take(100)(
            fizzBuzz()
        )
    ))


# GENERIC -------------------------------------------------

# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    '''The prefix of xs of length n,
       or xs itself if n > length xs.
    '''
    return lambda xs: (
        xs[0:n]
        if isinstance(xs, (list, tuple))
        else list(islice(xs, n))
    )


# unlines :: [String] -> String
def unlines(xs):
    '''A single string formed by the intercalation
       of a list of strings with the newline character.
    '''
    return '\n'.join(xs)


if __name__ == '__main__':
    main()
