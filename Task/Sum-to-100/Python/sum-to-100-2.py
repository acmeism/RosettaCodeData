import itertools
from collections import defaultdict, Counter

s = "123456789"
h = defaultdict(list)
for v in itertools.product(["+", "-", ""], repeat=9):
    if v[0] != "+":
        e = "".join("".join(u) for u in zip(v, s))
        h[eval(e)].append(e)

print("Solutions for 100")
for e in h[100]:
    print(e)

c = Counter({k: len(v) for k, v in h.items() if k >= 0})

k, m = c.most_common(1)[0]
print("Maximum number of solutions for %d (%d solutions)" % (k, m))

v = sorted(c.keys())

for i in range(v[-1]):
    if i not in c:
        print("Lowest impossible sum: %d" % i)
        break

print("Ten highest sums")
for k in reversed(v[-10:]):
    print(k)
