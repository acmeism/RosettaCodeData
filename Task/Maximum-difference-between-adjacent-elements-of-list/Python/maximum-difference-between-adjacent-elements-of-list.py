'''Maximum difference between adjacent numbers in list'''


# maxDeltas [Float] -> [(Float, (Float, Float))]
def maxDeltas(ns):
    '''Each of the maximally differing successive pairs
       in ns, each preceded by the value of the difference.
    '''
    pairs = [
        (abs(a - b), (a, b)) for a, b
        in zip(ns, ns[1:])
    ]
    delta = max(pairs, key=lambda ab: ab[0])[0]

    return [
        ab for ab in pairs
        if delta == ab[0]
    ]


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Each of the maximally differing pairs in a list'''

    maxPairs = maxDeltas([
        1, 8, 2, -3, 0, 1, 1, -2.3, 0,
        5.5, 8, 6, 2, 9, 11, 10, 3
    ])

    for ab in maxPairs:
        print(ab)


# MAIN ---
if __name__ == '__main__':
    main()
