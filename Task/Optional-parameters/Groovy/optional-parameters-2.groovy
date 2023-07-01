def table = [['a', 'b', 'c'], ['', 'q', 'z'], ['zap', 'zip', 'Zot']]

assert orderedSort(table) == [['', 'q', 'z'], ['a', 'b', 'c'], ['zap', 'zip', 'Zot']]
assert orderedSort(table, 2) == [['zap', 'zip', 'Zot'], ['a', 'b', 'c'], ['', 'q', 'z']]
assert orderedSort(table, 1) == [['a', 'b', 'c'], ['', 'q', 'z'], ['zap', 'zip', 'Zot']]
assert orderedSort(table, 1, true) == [['zap', 'zip', 'Zot'],['', 'q', 'z'],['a', 'b', 'c']]
assert orderedSort(table, 0, false, {x, y -> y?.size() <=> x?.size()} as Comparator) == [['zap', 'zip', 'Zot'],['a', 'b', 'c'],['', 'q', 'z']]
