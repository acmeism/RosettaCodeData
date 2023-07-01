"""Equilibrium index"""

from itertools import (accumulate)


# equilibriumIndices :: [Num] -> [Int]
def equilibriumIndices(xs):
    '''List indices at which the sum of values to the left
       equals the sum of values to the right.
    '''
    def go(xs):
        '''Left scan from accumulate,
           right scan derived from left
        '''
        ls = list(accumulate(xs))
        n = ls[-1]
        return [
            i for (i, (x, y)) in enumerate(zip(
                ls,
                [n] + [n - x for x in ls[0:-1]]
            )) if x == y
        ]
    return go(xs) if xs else []


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Tabulated test results'''
    print(
        tabulated('Equilibrium indices:\n')(
            equilibriumIndices
        )([
            [-7, 1, 5, 2, -4, 3, 0],
            [2, 4, 6],
            [2, 9, 2],
            [1, -1, 1, -1, 1, -1, 1],
            [1],
            []
        ])
    )


# ----------------------- GENERIC ------------------------

# tabulated :: String -> (a -> b) -> [a] -> String
def tabulated(s):
    '''heading -> function -> input List
       -> tabulated output string
    '''
    def go(f):
        def width(x):
            return len(str(x))
        def cols(xs):
            w = width(max(xs, key=width))
            return s + '\n' + '\n'.join([
                str(x).rjust(w, ' ') + ' -> ' + str(f(x))
                for x in xs
            ])
        return cols
    return go


if __name__ == '__main__':
    main()
