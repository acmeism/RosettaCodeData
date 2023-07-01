# AUTOMATIC CURRYING AND UNCURRYING OF EXISTING FUNCTIONS


# curry :: ((a, b) -> c) -> a -> b -> c
def curry(f):
    return lambda a: lambda b: f(a, b)


# uncurry :: (a -> b -> c) -> ((a, b) -> c)
def uncurry(f):
    return lambda x, y: f(x)(y)


# EXAMPLES --------------------------------------

# A plain uncurried function with 2 arguments,

# justifyLeft :: Int -> String -> String
def justifyLeft(n, s):
    return (s + (n * ' '))[:n]


# and a similar, but manually curried, function.

# justifyRight :: Int -> String -> String
def justifyRight(n):
    return lambda s: (
        ((n * ' ') + s)[-n:]
    )


# CURRYING and UNCURRYING at run-time:

def main():
    for s in [
        'Manually curried using a lambda:',
        '\n'.join(map(
            justifyRight(5),
            ['1', '9', '10', '99', '100', '1000']
        )),

        '\nAutomatically uncurried:',
        uncurry(justifyRight)(5, '10000'),

        '\nAutomatically curried',
        '\n'.join(map(
            curry(justifyLeft)(10),
            ['1', '9', '10', '99', '100', '1000']
        ))
    ]:
        print (s)


main()
