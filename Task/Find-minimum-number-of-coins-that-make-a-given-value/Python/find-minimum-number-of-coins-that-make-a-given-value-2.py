'''Minimum number of coins to make a given value'''


# change :: [Int] -> Int -> [(Int, Int)]
def change(xs):
    '''A list of (quantity, denomination) pairs.
       Unused denominations are excluded from the list.
    '''
    def go(n):
        if xs and n:
            h, *t = xs
            q, r = divmod(n, h)

            return ([(q, h)] if q else []) + (
                change(t)(r)
            )
        else:
            return []

    return go


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Testing a set of denominations with two sums'''

    f = change([200, 100, 50, 20, 10, 5, 2, 1])
    print(
        "\n".join([
            f'Summing to {n}:\n' + "\n".join([
                f'{qu[0]} * {qu[1]}' for qu in f(n)]
            ) + "\n"
            for n in [1024, 988]
        ])
    )


# MAIN ---
if __name__ == '__main__':
    main()
