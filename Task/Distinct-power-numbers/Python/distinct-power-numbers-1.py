from itertools import product
print(sorted(set(a**b for (a,b) in product(range(2,6), range(2,6)))))
