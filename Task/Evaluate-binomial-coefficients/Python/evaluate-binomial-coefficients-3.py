'''Evaluation of binomial coefficients'''

from functools import reduce


# binomialCoefficient :: Int -> Int -> Int
def binomialCoefficient(n):
    '''n choose k, expressed in terms of
       product and factorial functions.
    '''
    return lambda k: product(
        enumFromTo(1 + k)(n)
    ) // factorial(n - k)


# TEST ----------------------------------------------------
# main :: IO()
def main():
    '''Tests'''

    print(
        binomialCoefficient(5)(3)
    )

    # k=0 to k=5, where n=5
    print(
        list(map(
            binomialCoefficient(5),
            enumFromTo(0)(5)
        ))
    )


# GENERIC -------------------------------------------------

# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# factorial :: Int -> Int
def factorial(x):
    '''The factorial of x, where
       x is a positive integer.
    '''
    return product(enumFromTo(1)(x))


# product :: [Num] -> Num
def product(xs):
    '''The product of a list of
       numeric values.
    '''
    return reduce(lambda a, b: a * b, xs, 1)


# TESTS ---------------------------------------------------
if __name__ == '__main__':
    main()
