import itertools
items = [1, 2, 3, 'a', 'b', 'c', 2, 3, 4, 'b', 'c', 'd']
unique = [k for k,g in itertools.groupby(sorted(items))]
