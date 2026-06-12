'''Sorted string'''

from functools import reduce


# qSort :: [a] -> [a]
def qSort(xs):
    '''Sorted elements of the list xs, where the values
       of xs are assumed to be of some orderable type.
    '''
    if xs:
        h = xs[0]
        below, above = partition(
            lambda v: v <= h
        )(xs[1:])

        return qSort(below) + [h] + qSort(above)
    else:
        return []


# ------------------------- TEST -------------------------
def main():
    '''A character-sorted version of a test string
    '''
    print(quoted('"')(
        ''.join(qSort(list(
            "Is this misspelling of alphabetical as alphabitical a joke ?"
        )))
    ))


# ----------------------- GENERIC ------------------------

# partition :: (a -> Bool) -> [a] -> ([a], [a])
def partition(p):
    '''The pair of lists of those elements in xs
       which respectively do, and don't
       satisfy the predicate p.
    '''
    def go(a, x):
        ts, fs = a
        return (ts + [x], fs) if p(x) else (ts, fs + [x])
    return lambda xs: reduce(go, xs, ([], []))


# quoted :: Char -> String -> String
def quoted(c):
    '''A string flanked on both sides
       by a specified quote character.
    '''
    return lambda s: c + s + c


# MAIN ---
if __name__ == '__main__':
    main()
