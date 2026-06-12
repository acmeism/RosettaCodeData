'''Coprimes'''

from math import gcd


# coprime :: Int -> Int -> Bool
def coprime(a, b):
    '''True if a and b are coprime.
    '''
    return 1 == gcd(a, b)


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''List of pairs filtered for coprimes'''

    print([
        xy for xy in [
            (21, 15), (17, 23), (36, 12),
            (18, 29), (60, 15)
        ]
        if coprime(*xy)
    ])


# MAIN ---
if __name__ == '__main__':
    main()
