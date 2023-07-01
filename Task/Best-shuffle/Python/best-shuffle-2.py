#!/usr/bin/env python

def best_shuffle(s):
    # Count the supply of characters.
    from collections import defaultdict
    count = defaultdict(int)
    for c in s:
        count[c] += 1

    # Shuffle the characters.
    r = []
    for x in s:
        # Find the best character to replace x.
        best = None
        rankb = -2
        for c, rankc in count.items():
            # Prefer characters with more supply.
            # (Save characters with less supply.)
            # Avoid identical characters.
            if c == x: rankc = -1
            if rankc > rankb:
                best = c
                rankb = rankc

        # Add character to list. Remove it from supply.
        r.append(best)
        count[best] -= 1
        if count[best] >= 0: del count[best]

    # If the final letter became stuck (as "ababcd" became "bacabd",
    # and the final "d" became stuck), then fix it.
    i = len(s) - 1
    if r[i] == s[i]:
        for j in range(i):
            if r[i] != s[j] and r[j] != s[i]:
                r[i], r[j] = r[j], r[i]
                break

    # Convert list to string. PEP 8, "Style Guide for Python Code",
    # suggests that ''.join() is faster than + when concatenating
    # many strings. See http://www.python.org/dev/peps/pep-0008/
    r = ''.join(r)

    score = sum(x == y for x, y in zip(r, s))

    return (r, score)

for s in "abracadabra", "seesaw", "elk", "grrrrrr", "up", "a":
    shuffled, score = best_shuffle(s)
    print("%s, %s, (%d)" % (s, shuffled, score))
