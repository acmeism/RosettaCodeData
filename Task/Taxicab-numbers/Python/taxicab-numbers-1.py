from collections import defaultdict
from itertools import product
from pprint import pprint as pp

cube2n = {x**3:x for x in range(1, 1201)}
sum2cubes = defaultdict(set)
for c1, c2 in product(cube2n, cube2n):
	if c1 >= c2: sum2cubes[c1 + c2].add((cube2n[c1], cube2n[c2]))
	
taxied = sorted((k, v) for k,v in sum2cubes.items() if len(v) >= 2)

#pp(len(taxied))  # 2068
for t in enumerate(taxied[:25], 1):
    pp(t)
print('...')
for t in enumerate(taxied[2000-1:2000+6], 2000):
    pp(t)
