'''Dinesman's multiple-dwelling problem'''

from itertools import permutations

print([
    (
        'Baker on ' + str(b),
        'Cooper on ' + str(c),
        'Fletcher on ' + str(f),
        'Miller on ' + str(m),
        'Smith on ' + str(s)
    ) for [b, c, f, m, s] in permutations(range(1, 6))
    if all([
        5 != b,
        1 != c,
        1 != f,
        5 != f,
        c < m,
        1 < abs(s - f),
        1 < abs(c - f)
    ])
])
