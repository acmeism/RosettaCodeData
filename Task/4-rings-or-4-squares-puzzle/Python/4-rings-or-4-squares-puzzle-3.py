'''4-rings or 4-squares puzzle'''

from itertools import chain


# rings :: noRepeatedDigits -> DigitList -> Lists of solutions
# rings :: Bool -> [Int] -> [[Int]]
def rings(uniq):
    '''Sets of unique or non-unique integer values
       (drawn from the `digits` argument)
       for each of the seven names [a..g] such that:
       (a + b) == (b + c + d) == (d + e + f) == (f + g)
    '''
    def go(digits):
        ns = sorted(digits, reverse=True)
        h = ns[0]

        # CENTRAL DIGIT :: d
        def central(d):
            xs = list(filter(lambda x: h >= (d + x), ns))

            # LEFT NEIGHBOUR AND LEFTMOST :: c and a
            def left(c):
                a = c + d
                if a > h:
                    return []
                else:
                    # RIGHT NEIGHBOUR AND RIGHTMOST :: e and g
                    def right(e):
                        g = d + e
                        if ((g > h) or (uniq and (g == c))):
                            return []
                        else:
                            agDelta = a - g
                            bfs = difference(ns)(
                                [d, c, e, g, a]
                            ) if uniq else ns

                            # MID LEFT AND RIGHT :: b and f
                            def midLeftRight(b):
                                f = b + agDelta
                                return [[a, b, c, d, e, f, g]] if (
                                    (f in bfs) and (
                                        (not uniq) or (
                                            f not in [a, b, c, d, e, g]
                                        )
                                    )
                                ) else []

    # CANDIDATE DIGITS BOUND TO POSITIONS [a .. g] --------

                            return concatMap(midLeftRight)(bfs)

                    return concatMap(right)(
                        difference(xs)([d, c, a]) if uniq else ns
                    )

            return concatMap(left)(
                delete(d)(xs) if uniq else ns
            )

        return concatMap(central)(ns)

    return lambda digits: go(digits) if digits else []


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Testing unique digits [1..7], [3..9] and unrestricted digits'''

    print(main.__doc__ + ':\n')
    print(unlines(map(
        lambda tpl: '\nrings' + repr(tpl) + ':\n\n' + unlines(
            map(repr, uncurry(rings)(*tpl))
        ), [
            (True, enumFromTo(1)(7)),
            (True, enumFromTo(3)(9))
        ]
    )))
    tpl = (False, enumFromTo(0)(9))
    print(
        '\n\nlen(rings' + repr(tpl) + '):\n\n' +
        str(len(uncurry(rings)(*tpl)))
    )


# GENERIC -------------------------------------------------

# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been mapped.
       The list monad can be derived by using a function f which
       wraps its output in a list,
       (using an empty list to represent computational failure).
    '''
    return lambda xs: list(
        chain.from_iterable(map(f, xs))
    )


# delete :: Eq a => a -> [a] -> [a]
def delete(x):
    '''xs with the first of any instances of x removed.'''
    def go(xs):
        xs.remove(x)
        return xs
    return lambda xs: go(list(xs)) if (
        x in xs
    ) else list(xs)


#  difference :: Eq a => [a] -> [a] -> [a]
def difference(xs):
    '''All elements of ys except any also found in xs'''
    def go(ys):
        s = set(ys)
        return [x for x in xs if x not in s]
    return lambda ys: go(ys)


# enumFromTo :: (Int, Int) -> [Int]
def enumFromTo(m):
    '''Integer enumeration from m to n.'''
    return lambda n: list(range(m, 1 + n))


# uncurry :: (a -> b -> c) -> ((a, b) -> c)
def uncurry(f):
    '''A function over a pair of arguments,
       derived from a vanilla or curried function.
    '''
    return lambda x, y: f(x)(y)


# unlines :: [String] -> String
def unlines(xs):
    '''A single string formed by the intercalation
       of a list of strings with the newline character.
    '''
    return '\n'.join(xs)


# MAIN ---
if __name__ == '__main__':
    main()
