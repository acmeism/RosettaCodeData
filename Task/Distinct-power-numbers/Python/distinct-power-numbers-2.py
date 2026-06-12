'''Distinct power numbers'''

from itertools import product, starmap


# distinctPowerNumbers :: Int -> Int -> [Int]
def distinctPowerNumbers(a):
    '''Sorted values of x^y where x, y <- [a..b]
    '''
    def go(b):
        xs = range(a, 1 + b)

        return sorted(set(
            starmap(pow, product(xs, xs))
        ))

    return go


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Distinct powers from integers [2..5]'''

    print(
        distinctPowerNumbers(2)(5)
    )


# MAIN ---
if __name__ == '__main__':
    main()
