from itertools import count, islice, takewhile
from math import gcd

def EKG_gen(start=2):
    """\
    Generate the next term of the EKG together with the minimum cache of
    numbers left in its production; (the "state" of the generator).
    Using math.gcd
    """
    c = count(start + 1)
    last, so_far = start, list(range(2, start))
    yield 1, []
    yield last, []
    while True:
        for index, sf in enumerate(so_far):
            if gcd(last, sf) > 1:
                last = so_far.pop(index)
                yield last, so_far[::]
                break
        else:
            so_far.append(next(c))

def find_convergence(ekgs=(5,7)):
    "Returns the convergence point or zero if not found within the limit"
    ekg = [EKG_gen(n) for n in ekgs]
    for e in ekg:
        next(e)    # skip initial 1 in each sequence
    return 2 + len(list(takewhile(lambda state: not all(state[0] == s for  s in state[1:]),
                                  zip(*ekg))))

if __name__ == '__main__':
    for start in 2, 5, 7, 9, 10:
        print(f"EKG({start}):", str([n[0] for n in islice(EKG_gen(start), 10)])[1: -1])
    print(f"\nEKG(5) and EKG(7) converge at term {find_convergence(ekgs=(5,7))}!")
