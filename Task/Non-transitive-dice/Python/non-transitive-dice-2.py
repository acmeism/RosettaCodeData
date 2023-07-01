from collections import namedtuple
from itertools import permutations, product
from functools import lru_cache


Die = namedtuple('Die', 'name, faces')

@lru_cache(maxsize=None)
def cmpd(die1, die2):
    'compares two die returning 1, -1 or 0 for >, < =='
    # Numbers of times one die wins against the other for all combinations
    # cmp(x, y) is `(x > y) - (y > x)` to return 1, 0, or -1 for numbers
    tot = [0, 0, 0]
    for d1, d2 in product(die1.faces, die2.faces):
        tot[1 + (d1 > d2) - (d2 > d1)] += 1
    win2, _, win1 = tot
    return (win1 > win2) - (win2 > win1)

def is_non_trans(dice):
    "Check if ordering of die in dice is non-transitive returning dice or None"
    check = (all(cmpd(c1, c2) == -1
                 for c1, c2 in zip(dice, dice[1:]))  # Dn < Dn+1
             and cmpd(dice[0], dice[-1]) ==  1)      # But D[0] > D[-1]
    return dice if check else False

def find_non_trans(alldice, n=3):
    return [perm for perm in permutations(alldice, n)
            if is_non_trans(perm)]

def possible_dice(sides, mx):
    print(f"\nAll possible 1..{mx} {sides}-sided dice")
    dice = [Die(f"D{n+1}", faces)
            for n, faces in enumerate(product(range(1, mx+1), repeat=sides))]
    print(f'  Created {len(dice)} dice')
    print('  Remove duplicate with same bag of numbers on different faces')
    found = set()
    filtered = []
    for d in dice:
        count = tuple(sorted(d.faces))
        if count not in found:
            found.add(count)
            filtered.append(d)
    l = len(filtered)
    print(f'   Return {l} filtered dice')
    return filtered

#%% more verbose extra checks
def verbose_cmp(die1, die2):
    'compares two die returning their relationship of their names as a string'
    # Numbers of times one die wins against the other for all combinations
    win1 = sum(d1 > d2 for d1, d2 in product(die1.faces, die2.faces))
    win2 = sum(d2 > d1 for d1, d2 in product(die1.faces, die2.faces))
    n1, n2 = die1.name, die2.name
    return f'{n1} > {n2}' if win1 > win2 else (f'{n1} < {n2}' if win1 < win2 else f'{n1} = {n2}')

def verbose_dice_cmp(dice):
    c = [verbose_cmp(x, y) for x, y in zip(dice, dice[1:])]
    c += [verbose_cmp(dice[0], dice[-1])]
    return ', '.join(c)


#%% Use
if __name__ == '__main__':
    dice = possible_dice(sides=4, mx=4)
    for N in (3, 4):   # length of non-transitive group of dice searched for
        non_trans = find_non_trans(dice, N)
        print(f'\n  Non_transitive length-{N} combinations found: {len(non_trans)}')
        for lst in non_trans:
            print()
            for i, die in enumerate(lst):
                print(f"    {' ' if i else '['}{die}{',' if i < N-1 else ']'}")
        if non_trans:
            print('\n  More verbose comparison of last non_transitive result:')
            print(' ',   verbose_dice_cmp(non_trans[-1]))
        print('\n  ====')
