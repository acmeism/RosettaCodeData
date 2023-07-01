'''Disjoint sublist sorting'''


# --------------------- DISJOINT SORT ----------------------

# disjointSort :: [Int] -> [Int] -> [Int]
def disjointSort(ixs):
    '''A copy of the list xs, in which the disjoint sublist
       of items at zero-based indexes ixs is sorted in a
       default numeric or lexical order.'''
    def go(xs):
        ks = sorted(ixs)
        dct = dict(zip(ks, sorted(xs[k] for k in ks)))
        return [
            dct[i] if i in dct else x
            for i, x in enumerate(xs)
        ]
    return go


# -------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''Disjoint sublist at three indices.'''
    print(
        tabulated(
            'Disjoint sublist at indices [6, 1, 7] sorted:\n'
        )
        (str)(str)(
            disjointSort([6, 1, 7])
        )([
            [7, 6, 5, 4, 3, 2, 1, 0],
            ['h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
        ])
    )


# ------------------------ DISPLAY -------------------------

# tabulated :: String -> (a -> String) ->
#                        (b -> String) ->
#                        (a -> b) -> [a] -> String
def tabulated(s):
    '''Heading -> x display function -> fx display function ->
                f -> value list -> tabular string.'''
    def go(xShow, fxShow, f, xs):
        w = max(map(compose(len)(xShow), xs))
        return s + '\n' + '\n'.join(
            xShow(x).rjust(w, ' ') + ' -> ' + fxShow(f(x)) for x in xs
        )
    return lambda xShow: lambda fxShow: lambda f: lambda xs: go(
        xShow, fxShow, f, xs
    )

# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Function composition.'''
    return lambda f: lambda x: g(f(x))


if __name__ == '__main__':
    main()
