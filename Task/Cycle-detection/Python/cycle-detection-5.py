# cycleLength :: Eq a => [a] -> Maybe Int
def cycleLength(xs):
    '''Just the length of the first cycle found,
       or Nothing if no cycle seen.'''

    # f :: (Int, Int, Int, [Int]) -> (Int, Int, Int, [Int])
    def f(tpl):
        pwr, lng, x, ys = tpl
        y, *yt = ys
        return (2 * pwr, 1, y, yt) if (
            lng == pwr
        ) else (pwr, 1 + lng, x, yt)

    # p :: (Int, Int, Int, [Int]) -> Bool
    def p(tpl):
        _, _, x, ys = tpl
        return (not ys) or x == ys[0]

    if xs:
        _, lng, x, ys = until(p)(f)(
            (1, 1, xs[0], xs[1:])
        )
        return (
            Just(lng) if (x == ys[0]) else Nothing()
        ) if ys else Nothing()
    else:
        return Nothing()
