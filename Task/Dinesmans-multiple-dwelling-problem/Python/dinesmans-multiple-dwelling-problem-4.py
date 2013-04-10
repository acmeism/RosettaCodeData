from itertools import permutations

class Names:
    Baker, Cooper, Fletcher, Miller, Smith = range(5)
    seq = [Baker, Cooper, Fletcher, Miller, Smith]
    strings = "Baker Cooper Fletcher Miller Smith".split()

predicates = [
    lambda s: s[Names.Baker] != len(s)-1,
    lambda s: s[Names.Cooper] != 0,
    lambda s: s[Names.Fletcher] != 0 and s[Names.Fletcher] != len(s)-1,
    lambda s: s[Names.Miller] > s[Names.Cooper],
    lambda s: abs(s[Names.Smith] - s[Names.Fletcher]) != 1,
    lambda s: abs(s[Names.Cooper] - s[Names.Fletcher]) != 1];

for sol in permutations(Names.seq):
    if all(p(sol) for p in predicates):
        print " ".join(Names.strings[s] for s in sol)
