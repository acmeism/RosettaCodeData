from itertools import combinations as cmb


def isP(n):
    if n == 2:
        return True
    if n % 2 == 0:
        return False
    return all(n % x > 0 for x in range(3, int(n ** 0.5) + 1, 2))


def genP(n):
    p = [2]
    p.extend([x for x in range(3, n + 1, 2) if isP(x)])
    return p


data = [
    (99809, 1), (18, 2), (19, 3), (20, 4), (2017, 24),
    (22699, 1), (22699, 2), (22699, 3), (22699, 4), (40355, 3)]


for n, cnt in data:
    ci = iter(cmb(genP(n), cnt))
    while True:
        try:
            c = next(ci)
            if sum(c) == n:
                print(' '.join(
                    [repr((n, cnt)), "->", '+'.join(str(s) for s in c)]
                ))
                break
        except StopIteration:
            print(repr((n, cnt)) + " -> Not possible")
            break
