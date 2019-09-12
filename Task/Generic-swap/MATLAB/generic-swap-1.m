>> a = [30 40 50 60 70]

a =

    30    40    50    60    70

>> a([1 3]) = a([3 1]) %Single swap

a =

    50    40    30    60    70

>> a([1 2 4 3]) = a([2 3 1 4]) %Multiple swap, a.k.a permutation.

a =

    40    30    60    50    70
