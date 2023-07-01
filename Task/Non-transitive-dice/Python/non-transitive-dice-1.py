from itertools import combinations_with_replacement as cmbr
from time import time

def dice_gen(n, faces, m):
    dice = list(cmbr(faces, n))

    succ = [set(j for j, b in enumerate(dice)
                    if sum((x>y) - (x<y) for x in a for y in b) > 0)
                for a in dice]

    def loops(seq):
        s = succ[seq[-1]]

        if len(seq) == m:
            if seq[0] in s: yield seq
            return

        for d in (x for x in s if x > seq[0] and not x in seq):
            yield from loops(seq + (d,))

    yield from (tuple(''.join(dice[s]) for s in x)
                    for i, v in enumerate(succ)
                    for x in loops((i,)))

t = time()
for n, faces, loop_len in [(4, '1234', 3), (4, '1234', 4), (6, '123456', 3), (6, '1234567', 3)]:
    for i, x in enumerate(dice_gen(n, faces, loop_len)): pass

    print(f'{n}-sided, markings {faces}, loop length {loop_len}:')
    print(f'\t{i + 1}*{loop_len} solutions, e.g. {" > ".join(x)} > [loop]')
    t, t0 = time(), t
    print(f'\ttime: {t - t0:.4f} seconds\n')
