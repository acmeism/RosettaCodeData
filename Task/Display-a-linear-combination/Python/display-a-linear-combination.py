def linear(x):
    return ' + '.join(['{}e({})'.format('-' if v == -1 else '' if v == 1 else str(v) + '*', i + 1)
        for i, v in enumerate(x) if v] or ['0']).replace(' + -', ' - ')

list(map(lambda x: print(linear(x)), [[1, 2, 3], [0, 1, 2, 3], [1, 0, 3, 4], [1, 2, 0],
        [0, 0, 0], [0], [1, 1, 1], [-1, -1, -1], [-1, -2, 0, 3], [-1]]))
