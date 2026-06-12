'''Steady Squares'''

from itertools import accumulate, chain, count, takewhile
from operator import add


def main():
    '''Numbers up to 10000 which have steady squares'''
    print(
        '\n'.join(
            f'{a} -> {b}' for (a, b) in takewhile(
                lambda ab: 10000 > ab[0],
                enumerate(
                    accumulate(
                        chain([0], count(1, 2)),
                        add
                    )
                )
            ) if str(b).endswith(str(a))
        )
    )


# MAIN ---
if __name__ == '__main__':
    main()
