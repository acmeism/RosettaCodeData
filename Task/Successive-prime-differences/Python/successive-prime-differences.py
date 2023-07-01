# https://docs.sympy.org/latest/index.html
from sympy import Sieve

def nsuccprimes(count, mx):
    "return tuple of <count> successive primes <= mx (generator)"
    sieve = Sieve()
    sieve.extend(mx)
    primes = sieve._list
    return zip(*(primes[n:] for n in range(count)))

def check_value_diffs(diffs, values):
    "Differences between successive values given by successive items in diffs?"
    return all(v[1] - v[0] == d
               for d, v in zip(diffs, zip(values, values[1:])))

def successive_primes(offsets=(2, ), primes_max=1_000_000):
    return (sp for sp in nsuccprimes(len(offsets) + 1, primes_max)
            if check_value_diffs(offsets, sp))

if __name__ == '__main__':
    for offsets, mx in [((2,),      1_000_000),
                        ((1,),      1_000_000),
                        ((2, 2),    1_000_000),
                        ((2, 4),    1_000_000),
                        ((4, 2),    1_000_000),
                        ((6, 4, 2), 1_000_000),
                       ]:
        print(f"## SETS OF {len(offsets)+1} SUCCESSIVE PRIMES <={mx:_} WITH "
              f"SUCCESSIVE DIFFERENCES OF {str(list(offsets))[1:-1]}")
        for count, last in enumerate(successive_primes(offsets, mx), 1):
            if count == 1:
                first = last
        print("  First group:", str(first)[1:-1])
        print("   Last group:", str(last)[1:-1])
        print("        Count:", count)
