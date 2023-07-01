def table = [['a', 'b', 'c'], ['', 'q', 'z'], ['zap', 'zip', 'Zot']]

assert table.orderedSort() == [['', 'q', 'z'], ['a', 'b', 'c'], ['zap', 'zip', 'Zot']]
assert table.orderedSort(column: 2) == [['zap', 'zip', 'Zot'], ['a', 'b', 'c'], ['', 'q', 'z']]
assert table.orderedSort(column: 1) == [['a', 'b', 'c'], ['', 'q', 'z'], ['zap', 'zip', 'Zot']]
assert table.orderedSort(column: 1, reverse: true) == [['zap', 'zip', 'Zot'],['', 'q', 'z'],['a', 'b', 'c']]
assert table.orderedSort(ordering: {x, y -> y?.size() <=> x?.size()} as Comparator) == [['zap', 'zip', 'Zot'],['a', 'b', 'c'],['', 'q', 'z']]
