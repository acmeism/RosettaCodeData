'''Approximation of E'''

from functools import reduce


# eApprox :: Int -> Float
def eApprox(n):
    '''Approximation of E obtained after N iterations.
    '''
    def go(efl, x):
        e, fl = efl
        flx = fl * x
        return e + 1 / flx, flx

    return reduce(
        go,
        range(1, 1 + n),
        (1, 1)
    )[0]


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Approximation of E obtained after 20 iterations.'''

    print(eApprox(20))


# MAIN ---
if __name__ == '__main__':
    main()
