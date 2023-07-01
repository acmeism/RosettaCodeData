from math import (acos, cos, asin, sin)


# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g, f):
    '''Right to left function composition.'''
    return lambda x: g(f(x))


# main :: IO ()
def main():
    '''Test'''

    print(list(map(
        lambda f: f(0.5),
        zipWith(compose)(
            [sin, cos, lambda x: x ** 3.0]
        )([asin, acos, lambda x: x ** (1 / 3.0)])
    )))


# GENERIC FUNCTIONS ---------------------------------------


# zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
def zipWith(f):
    '''A list constructed by zipping with a
       custom function, rather than with the
       default tuple constructor.'''
    return lambda xs: lambda ys: (
        map(f, xs, ys)
    )


if __name__ == '__main__':
    main()
