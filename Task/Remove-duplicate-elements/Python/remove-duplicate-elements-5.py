from collections import OrderedDict as od

print(list(od.fromkeys([1, 2, 3, 'a', 'b', 'c', 2, 3, 4, 'b', 'c', 'd']).keys()))
