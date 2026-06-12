'''First square prefixed by digits of N'''

from itertools import count


# firstSquareWithPrefix :: Int -> Int
def firstSquareWithPrefix(n):
    '''The first perfect square prefixed (in decimal)
       by the decimal digits of N.
    '''
    pfx = str(n)
    lng = len(pfx)
    return int(
        next(
            s for s in (
                str(x * x) for x in count(0)
            )
            if pfx == s[0:lng]
        )
    )


# ------------------------- TEST -------------------------
def main():
    '''First matches for the range [1..49]'''

    print('\n'.join([
        str(firstSquareWithPrefix(x)) for x in range(1, 50)
    ]))


# MAIN ---
if __name__ == '__main__':
    main()
