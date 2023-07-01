'''Towers of Hanoi'''


# hanoi :: Int -> String -> String -> String -> [(String, String)]
def hanoi(n):
    '''A list of (from, to) label pairs,
       where a, b and c are labels for each of the
       three Hanoi tower positions.'''
    def go(n, a, b, c):
        p = n - 1
        return (
            go(p, a, c, b) + [(a, b)] + go(p, c, b, a)
        ) if 0 < n else []
    return lambda a: lambda b: lambda c: go(n, a, b, c)


# TEST ----------------------------------------------------
if __name__ == '__main__':

    # fromTo :: (String, String) -> String
    def fromTo(xy):
        '''x -> y'''
        x, y = xy
        return x.rjust(5, ' ') + ' -> ' + y

    print(__doc__ + ':\n\n' + '\n'.join(
        map(fromTo, hanoi(4)('left')('right')('mid'))
    ))
