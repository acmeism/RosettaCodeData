from collections import defaultdict
days = 365

def find_half(c):

    # inc_people takes birthday combinations of n people and generates the
    # new set for n+1
    def inc_people(din, over):
        # 'over' is the number of combinations that have at least c people
        # sharing a birthday. These are not contained in the set.

        dout, over = defaultdict(int), over * days
        for k, s in din.items():
            for i, v in enumerate(k):
                if v + 1 >= c:
                    over += s
                else:
                    dout[tuple(sorted(k[0:i] + (v + 1,) + k[i+1:]))] += s
            dout[(1,) + k] += s * (days - len(k))
        return dout, over

    d, combos, good, n = {(): 1}, 1, 0, 0

    # increase number of people until at least half of the cases have at
    # at least c people sharing a birthday
    while True:
        n += 1
        combos *= days # or, combos = sum(d.values()) + good
        d, good = inc_people(d, good)

        #!!! print d.items()
        if good * 2 >= combos:
            return n, good, combos

for x in range(2, 5):
    n, good, combos = find_half(x)
    print("%d of %d people sharing birthday: %d out of %d combos"% (x, n, good, combos))
