'''Two identical strings'''

from itertools import count, takewhile


# binaryTwin :: Int -> (Int, String)
def binaryTwin(n):
    '''A tuple of an integer m and a string s, where
       s is a self-concatenation of the binary
       represention of n, and m is the integer value of s.
    '''
    s = bin(n)[2:] * 2
    return int(s, 2), s


# ------------------------- TEST -------------------------
def main():
    '''Numbers defined by duplicated binary sequences,
       up to a limit of decimal 1000.
    '''
    print(
        '\n'.join([
            repr(pair) for pair
            in takewhile(
                lambda x: 1000 > x[0],
                map(binaryTwin, count(1))
            )
        ])
    )


# MAIN ---
if __name__ == '__main__':
    main()
