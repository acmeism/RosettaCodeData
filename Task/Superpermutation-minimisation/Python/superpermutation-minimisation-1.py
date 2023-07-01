"Generate a short Superpermutation of n characters A... as a string using various algorithms."


from __future__ import print_function, division

from itertools import permutations
from math import factorial
import string
import datetime
import gc



MAXN = 7


def s_perm0(n):
    """
    Uses greedy algorithm of adding another char (or two, or three, ...)
    until an unseen perm is formed in the last n chars
    """
    allchars = string.ascii_uppercase[:n]
    allperms = [''.join(p) for p in permutations(allchars)]
    sp, tofind = allperms[0], set(allperms[1:])
    while tofind:
        for skip in range(1, n):
            for trial_add in (''.join(p) for p in permutations(sp[-n:][:skip])):
                #print(sp, skip, trial_add)
                trial_perm = (sp + trial_add)[-n:]
                if trial_perm in tofind:
                    #print(sp, skip, trial_add)
                    sp += trial_add
                    tofind.discard(trial_perm)
                    trial_add = None    # Sentinel
                    break
            if trial_add is None:
                break
    assert all(perm in sp for perm in allperms) # Check it is a superpermutation
    return sp

def s_perm1(n):
    """
    Uses algorithm of concatenating all perms in order if not already part
    of concatenation.
    """
    allchars = string.ascii_uppercase[:n]
    allperms = [''.join(p) for p in sorted(permutations(allchars))]
    perms, sp = allperms[::], ''
    while perms:
        nxt = perms.pop()
        if nxt not in sp:
            sp += nxt
    assert all(perm in sp for perm in allperms)
    return sp

def s_perm2(n):
    """
    Uses algorithm of concatenating all perms in order first-last-nextfirst-
    nextlast... if not already part of concatenation.
    """
    allchars = string.ascii_uppercase[:n]
    allperms = [''.join(p) for p in sorted(permutations(allchars))]
    perms, sp = allperms[::], ''
    while perms:
        nxt = perms.pop(0)
        if nxt not in sp:
            sp += nxt
        if perms:
            nxt = perms.pop(-1)
            if nxt not in sp:
                sp += nxt
    assert all(perm in sp for perm in allperms)
    return sp

def _s_perm3(n, cmp):
    """
    Uses algorithm of concatenating all perms in order first,
    next_with_LEASTorMOST_chars_in_same_position_as_last_n_chars, ...
    """
    allchars = string.ascii_uppercase[:n]
    allperms = [''.join(p) for p in sorted(permutations(allchars))]
    perms, sp = allperms[::], ''
    while perms:
        lastn = sp[-n:]
        nxt = cmp(perms,
                  key=lambda pm:
                    sum((ch1 == ch2) for ch1, ch2 in zip(pm, lastn)))
        perms.remove(nxt)
        if nxt not in sp:
            sp += nxt
    assert all(perm in sp for perm in allperms)
    return sp

def s_perm3_max(n):
    """
    Uses algorithm of concatenating all perms in order first,
    next_with_MOST_chars_in_same_position_as_last_n_chars, ...
    """
    return _s_perm3(n, max)

def s_perm3_min(n):
    """
    Uses algorithm of concatenating all perms in order first,
    next_with_LEAST_chars_in_same_position_as_last_n_chars, ...
    """
    return _s_perm3(n, min)


longest = [factorial(n) * n for n in range(MAXN + 1)]
weight, runtime = {}, {}
print(__doc__)
for algo in [s_perm0, s_perm1, s_perm2, s_perm3_max, s_perm3_min]:
    print('\n###\n### %s\n###' % algo.__name__)
    print(algo.__doc__)
    weight[algo.__name__], runtime[algo.__name__] = 1, datetime.timedelta(0)
    for n in range(1, MAXN + 1):
        gc.collect()
        gc.disable()
        t = datetime.datetime.now()
        sp = algo(n)
        t = datetime.datetime.now() - t
        gc.enable()
        runtime[algo.__name__] += t
        lensp = len(sp)
        wt = (lensp / longest[n]) ** 2
        print('  For N=%i: SP length %5i Max: %5i Weight: %5.2f'
              % (n, lensp, longest[n], wt))
        weight[algo.__name__] *= wt
    weight[algo.__name__] **= 1 / n  # Geometric mean
    weight[algo.__name__] = 1 / weight[algo.__name__]
    print('%*s Overall Weight: %5.2f in %.1f seconds.'
          % (29, '', weight[algo.__name__], runtime[algo.__name__].total_seconds()))

print('\n###\n### Algorithms ordered by shortest superpermutations first\n###')
print('\n'.join('%12s (%.3f)' % kv for kv in
                sorted(weight.items(), key=lambda keyvalue: -keyvalue[1])))

print('\n###\n### Algorithms ordered by shortest runtime first\n###')
print('\n'.join('%12s (%.3f)' % (k, v.total_seconds()) for k, v in
                sorted(runtime.items(), key=lambda keyvalue: keyvalue[1])))
