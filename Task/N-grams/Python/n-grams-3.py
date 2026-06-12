from itertools import (islice)
from functools import (reduce)
from operator import (add)


def nGramCounts(n, s):
    '''A dictionary of all nGrams of dimension n in s,
       with the frequency of their occurrence.
    '''
    return reduce(
        lambda a, gram: insertWith(add, gram, 1, a),
        nGrams(n, s),
        {}
    )


def nGrams(n, s):
    '''All case-insensitive sequences of length n in the string s.'''
    return (''.join(t) for t in windows(n, list(s.upper())))


# ----------------------- GENERICS -----------------------

def insertWith(f, k, x, dct):
    '''A new dictionary updated with a
       (key, f(value, x)) tuple.
       Where there is no existing value for the key,
       the supplied x is used as the default.
    '''
    return dict(dct, **{k: f(dct[k], x) if k in dct else x})


def tails(xs):
    '''All final segments of xs, longest first.'''
    return (xs[i:] for i in range(0, 1 + len(xs)))


def windows(n, xs):
    '''Sliding windows of dimension n.'''
    return zip(*islice(tails(xs), n))



# ------------------------- TEST -------------------------
if __name__ == "__main__":
    import pprint

    EXAMPLE = "Live and let live"

    for dimension in range(1, 5):
        result = sorted(nGramCounts(dimension, EXAMPLE).items())
        print(
            f"{len(result)} {dimension}-grams of {EXAMPLE!r}:\n",
            pprint.pformat(result),
            end="\n\n",
        )
