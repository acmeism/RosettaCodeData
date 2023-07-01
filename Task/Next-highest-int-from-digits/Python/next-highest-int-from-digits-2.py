from itertools import permutations


def nexthigh(n):
    "Return next highest number from n's digits using search of all digit perms"
    assert n == int(abs(n)), "n >= 0"
    this = tuple(str(int(n)))
    perms = sorted(permutations(this))
    for perm in perms[perms.index(this):]:
        if perm != this:
            return int(''.join(perm))
    return 0
