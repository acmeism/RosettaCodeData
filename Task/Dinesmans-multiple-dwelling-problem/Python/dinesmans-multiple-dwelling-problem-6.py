'''Dinesman's multiple-dwelling problem'''

from itertools import chain, permutations


# main :: IO ()
def main():
    '''Solution or null result.'''
    print(report(
        concatMap(dinesman)(
            permutations(range(1, 6))
        )
    ))


# dinesman :: (Int, Int, Int, Int, Int) -> [(Int, Int, Int, Int, Int)]
def dinesman(bcfms):
    '''A list containing the given permutation of five
       integers if it matches all the dinesman conditions,
       or an empty list if it does not.
    '''
    [b, c, f, m, s] = bcfms
    return [bcfms] if all([
        5 != b,
        1 != c,
        1 != f,
        5 != f,
        c < m,
        1 < abs(s - f),
        1 < abs(c - f)
    ]) else []


# report :: [(Int, Int, Int, Int, Int)] ->  String
def report(xs):
    '''A message summarizing the first (if any) solution found.
    '''
    return ', '.join(list(map(
        lambda k, n: k + ' in ' + str(n),
        ['Baker', 'Cooper', 'Fletcher', 'Miller', 'Smith'],
        xs[0]
    ))) + '.' if xs else 'No solution found.'


# GENERAL -------------------------------------------------

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


# MAIN ---
if __name__ == '__main__':
    main()
