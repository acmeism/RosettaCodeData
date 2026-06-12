'''First missing natural number'''

from itertools import count


# firstGap :: [Int] -> Int
def firstGap(xs):
    '''First natural number not found in xs'''
    return next(x for x in count(1) if x not in xs)


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''First missing natural number in each list'''
    print('\n'.join([
        f'{repr(xs)} -> {firstGap(xs)}' for xs in [
            [1, 2, 0],
            [3, 4, -1, 1],
            [7, 8, 9, 11, 12]
        ]
    ]))


# MAIN ---
if __name__ == '__main__':
    main()
