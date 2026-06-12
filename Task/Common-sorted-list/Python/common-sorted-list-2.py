'''Common sorted list'''

from itertools import chain


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Sorted union of lists'''

    print(
        sorted(nub(concat([
            [5, 1, 3, 8, 9, 4, 8, 7],
            [3, 5, 9, 8, 4],
            [1, 3, 7, 9]
        ])))
    )


# ----------------------- GENERIC ------------------------

# concat :: [[a]] -> [a]
# concat :: [String] -> String
def concat(xs):
    '''The concatenation of all the elements in a list.
    '''
    return list(chain(*xs))


# nub :: [a] -> [a]
def nub(xs):
    '''A list containing the same elements as xs,
       without duplicates, in the order of their
       first occurrence.
    '''
    return list(dict.fromkeys(xs))


# MAIN ---
if __name__ == '__main__':
    main()
