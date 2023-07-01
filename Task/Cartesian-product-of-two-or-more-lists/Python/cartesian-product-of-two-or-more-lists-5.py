# Two lists -> list of tuples


# cartesianProduct :: [a] -> [b] -> [(a, b)]
def cartesianProduct(xs):
    return ap(map(Tuple, xs))


# List of lists -> list of tuples

# nAryCartProd :: [[a], [b], [c] ...] -> [(a, b, c ...)]
def nAryCartProd(xxs):
    return foldl1(cartesianProduct)(
        xxs
    )


# main :: IO ()
def main():
    # Product of lists of different types
    print (
        'Product of two lists of different types:'
    )
    print(
        cartesianProduct(['a', 'b', 'c'])(
            [1, 2]
        )
    )

    # TESTS OF PRODUCTS OF TWO LISTS

    print(
        '\nSpecified tests of products of two lists:'
    )
    print(
        cartesianProduct([1, 2])([3, 4]),
        ' <--> ',
        cartesianProduct([3, 4])([1, 2])
    )
    print (
        cartesianProduct([1, 2])([]),
        ' <--> ',
        cartesianProduct([])([1, 2])
    )

    # TESTS OF N-ARY CARTESIAN PRODUCTS

    print('\nSpecified tests of nAry products:')
    for xs in nAryCartProd([[1776, 1789], [7, 12], [4, 14, 23], [0, 1]]):
        print(xs)

    for xs in (
        map_(nAryCartProd)(
            [
                [[1, 2, 3], [30], [500, 100]],
                [[1, 2, 3], [], [500, 100]]
            ]
        )
    ):
        print(
            xs
        )

# GENERIC -------------------------------------------------


# Applicative function for lists

# ap (<*>) :: [(a -> b)] -> [a] -> [b]
def ap(fs):
    return lambda xs: foldl(
        lambda a: lambda f: a + foldl(
            lambda a: lambda x: a + [f(x)])([])(xs)
    )([])(fs)


# foldl :: (a -> b -> a) -> a -> [b] -> a
def foldl(f):
    def go(v, xs):
        a = v
        for x in xs:
            a = f(a)(x)
        return a
    return lambda acc: lambda xs: go(acc, xs)


# foldl1 :: (a -> a -> a) -> [a] -> a
def foldl1(f):
    return lambda xs: foldl(f)(xs[0])(
        xs[1:]
    ) if xs else None


# map :: (a -> b) -> [a] -> [b]
def map_(f):
    return lambda xs: list(map(f, xs))


# Tuple :: a -> b -> (a, b)
def Tuple(x):
    return lambda y: (
        x + (y,)
    ) if tuple is type(x) else (x, y)


# TEST ----------------------------------------------------
if __name__ == '__main__':
    main()
