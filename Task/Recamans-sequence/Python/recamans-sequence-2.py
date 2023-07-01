'''Recaman sequence'''


# recamanUntil :: (Int -> Set Int > [Int] -> Bool) -> [Int]
def recamanUntil(p):
    '''All terms of the Recaman series before the
       first term for which the predicate p holds.'''
    n = 1
    r = 0  # First term of series
    rs = [r]
    seen = set(rs)
    blnNew = True
    while not p(seen, n, r, blnNew):
        r = recamanSucc(seen, n, r)
        blnNew = r not in seen
        seen.add(r)
        rs.append(r)
        n = 1 + n
    return rs


# recamanSucc :: Set Int -> Int -> Int
def recamanSucc(seen, n, r):
    '''The successor for a given Recaman term,
       given the set of Recaman terms seen so far.'''
    back = r - n
    return n + r if 0 > back or (back in seen) else back


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Test'''
    print(
        'First 15 Recaman:\r',
        recamanUntil(
            lambda seen, n, r, _: 15 == n
        )
    )
    print(
        'First duplicated Recaman:\r',
        recamanUntil(
            lambda seen, n, r, blnNew: not blnNew
        )[-1]
    )
    setK = set(enumFromTo(0)(1000))
    print(
        'Number of Recaman terms needed to generate',
        'all integers from [0..1000]:\r',
        len(recamanUntil(
            lambda seen, n, r, blnNew: (
                blnNew and 1001 > r and setK.issubset(seen)
            )
        )) - 1
    )


# ----------------------- GENERIC ------------------------

# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: range(m, 1 + n)


if __name__ == '__main__':
    main()
