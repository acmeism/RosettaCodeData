'''Shift list elements to left by 3'''

from itertools import cycle, islice


# rotated :: Int -> [a] -> [a]
def rotated(n):
    '''A list rotated n elements to the left.'''
    def go(xs):
        lng = len(xs)
        stream = cycle(xs)

        # (n modulo lng) elements dropped from the start,
        list(islice(stream, n % lng))

        # and lng elements drawn from the remaining cycle.
        return list(islice(stream, lng))
    return go


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Positive and negative (left and right)
       rotations tested for list and range inputs.
    '''
    xs = [1, 2, 3, 4, 5, 6, 7, 8, 9]

    print("List rotated 3 positions to the left:")
    print(
        rotated(3)(xs)
    )
    print("List rotated 3 positions to the right:")
    print(
        rotated(-3)(xs)
    )
    print("\nLists obtained by rotations of an input range:")
    rng = range(1, 1 + 9)
    print(
        rotated(3)(rng)
    )
    print(
        rotated(-3)(rng)
    )


# MAIN ---
if __name__ == '__main__':
    main()
