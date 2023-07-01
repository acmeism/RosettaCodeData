from __future__ import print_function
from itertools import takewhile

maxsum = 99

def get_primes(max):
    if max < 2:
        return []
    lprimes = [2]
    for x in range(3, max + 1, 2):
        for p in lprimes:
            if x % p == 0:
                break
        else:
            lprimes.append(x)
    return lprimes

descendants = [[] for _ in range(maxsum + 1)]
ancestors = [[] for _ in range(maxsum + 1)]

primes = get_primes(maxsum)

for p in primes:
    descendants[p].append(p)
    for s in range(1, len(descendants) - p):
        descendants[s + p] += [p * pr for pr in descendants[s]]

for p in primes + [4]:
    descendants[p].pop()

total = 0
for s in range(1, maxsum + 1):
    descendants[s].sort()
    for d in takewhile(lambda x: x <= maxsum, descendants[s]):
        ancestors[d] = ancestors[s] + [s]
    print([s], "Level:", len(ancestors[s]))
    print("Ancestors:", ancestors[s] if len(ancestors[s]) else "None")
    print("Descendants:", len(descendants[s]) if len(descendants[s]) else "None")
    if len(descendants[s]):
        print(descendants[s])
    print()
    total += len(descendants[s])

print("Total descendants", total)
