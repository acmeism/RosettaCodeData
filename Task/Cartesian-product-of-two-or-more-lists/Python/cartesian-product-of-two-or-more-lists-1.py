import itertools

def cp(lsts):
    return list(itertools.product(*lsts))

if __name__ == '__main__':
    from pprint import pprint as pp

    for lists in [[[1,2],[3,4]], [[3,4],[1,2]], [[], [1, 2]], [[1, 2], []],
                  ((1776, 1789),  (7, 12), (4, 14, 23), (0, 1)),
                  ((1, 2, 3), (30,), (500, 100)),
                  ((1, 2, 3), (), (500, 100))]:
        print(lists, '=>')
        pp(cp(lists), indent=2)
