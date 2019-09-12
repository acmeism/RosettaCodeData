'''CRC-32 checksums for ascii strings'''

from functools import (reduce)
from itertools import (islice)


# crc32 :: String -> Int
def crc32(s):
    '''CRC-32 checksum for an ASCII encoded string'''
    def go(x):
        x2 = x >> 1
        return 0xedb88320 ^ x2 if x & 1 else x2
    table = [
        index(iterate(go)(n))(8)
        for n in range(0, 256)
    ]
    return reduce(
        lambda a, c: (a >> 8) ^ table[
            (a ^ ord(c)) & 0xff
        ],
        list(s),
        (0xffffffff)
    ) ^ 0xffffffff


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Test'''
    print(
        format(
            crc32('The quick brown fox jumps over the lazy dog'),
            '02x'
        )
    )


# GENERIC ABSTRACTION -------------------------------------

# index (!!) :: [a] -> Int -> a
def index(xs):
    '''Item at given (zero-based) index.'''
    return lambda n: None if 0 > n else (
        xs[n] if (
            hasattr(xs, "__getitem__")
        ) else next(islice(xs, n, None))
    )


# iterate :: (a -> a) -> a -> Gen [a]
def iterate(f):
    '''An infinite list of repeated applications of f to x.'''
    def go(x):
        v = x
        while True:
            yield v
            v = f(v)
    return lambda x: go(x)


if __name__ == '__main__':
    main()
