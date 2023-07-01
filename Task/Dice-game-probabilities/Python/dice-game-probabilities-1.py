from itertools import product

def gen_dict(n_faces, n_dice):
    counts = [0] * ((n_faces + 1) * n_dice)
    for t in product(range(1, n_faces + 1), repeat=n_dice):
        counts[sum(t)] += 1
    return counts, n_faces ** n_dice

def beating_probability(n_sides1, n_dice1, n_sides2, n_dice2):
    c1, p1 = gen_dict(n_sides1, n_dice1)
    c2, p2 = gen_dict(n_sides2, n_dice2)
    p12 = float(p1 * p2)

    return sum(p[1] * q[1] / p12
               for p, q in product(enumerate(c1), enumerate(c2))
               if p[0] > q[0])

print beating_probability(4, 9, 6, 6)
print beating_probability(10, 5, 7, 6)
