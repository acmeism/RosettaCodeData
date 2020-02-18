'''Nth Root'''

from decimal import Decimal, getcontext
from operator import eq


# nthRoot :: Int -> Int -> Int -> Real
def nthRoot(precision):
    '''The nth root of x at the given precision.'''
    def go(n, x):
        getcontext().prec = precision
        dcn = Decimal(n)

        def same(ab):
            return eq(*ab)

        def step(ab):
            a, b = ab
            predn = pred(dcn)
            return (
                b,
                reciprocal(dcn) * (
                    predn * a + (
                        x / (a ** predn)
                    )
                )
            )
        return until(same)(step)(
            (x / dcn, 1)
        )[0]
    return lambda n: lambda x: go(n, x)


# --------------------------TEST---------------------------
def main():
    '''Nth roots at various precisions'''

    def xShow(tpl):
        p, n, x = tpl
        return rootName(n) + (
            ' of ' + str(x) + ' at precision ' + str(p)
        )

    def f(tpl):
        p, n, x = tpl
        return nthRoot(p)(n)(x)

    print(
        fTable(main.__doc__ + ':\n')(xShow)(str)(f)(
            [(10, 5, 34), (20, 10, 42), (30, 2, 5)]
        )
    )


# -------------------------DISPLAY-------------------------

# fTable :: String -> (a -> String) ->
# (b -> String) -> (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function -> fx display function ->
       f -> xs -> tabular string.
    '''
    def go(xShow, fxShow, f, xs):
        ys = [xShow(x) for x in xs]
        w = max(map(len, ys))
        return s + '\n' + '\n'.join(map(
            lambda x, y: y.rjust(w, ' ') + ' -> ' + fxShow(f(x)),
            xs, ys
        ))
    return lambda xShow: lambda fxShow: lambda f: lambda xs: go(
        xShow, fxShow, f, xs
    )


# -------------------------GENERIC-------------------------

# rootName :: Int -> String
def rootName(n):
    '''English ordinal suffix.'''
    return ['identity', 'square root', 'cube root'][n - 1] if (
        4 > n or 1 > n
    ) else (str(n) + 'th root')


# pred ::  Enum a => a -> a
def pred(x):
    '''The predecessor of a value. For numeric types, (- 1).'''
    return x - 1


# reciprocal :: Num -> Num
def reciprocal(x):
    '''Arithmetic reciprocal of x.'''
    return 1 / x


# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.
    '''
    def go(f, x):
        v = x
        while not p(v):
            v = f(v)
        return v
    return lambda f: lambda x: go(f, x)


if __name__ == '__main__':
    main()
