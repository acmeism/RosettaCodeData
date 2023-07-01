from itertools import islice

def posd():
    "diff between position numbers. 1, 2, 3... interleaved with  3, 5, 7..."
    count, odd = 1, 3
    while True:
        yield count
        yield odd
        count, odd = count + 1, odd + 2

def pos_gen():
    "position numbers. 1 3 2 5 7 4 9 ..."
    val = 1
    diff = posd()
    while True:
        yield val
        val += next(diff)

def plus_minus():
    "yield (list_offset, sign) or zero for Partition calc"
    n, sign = 0, [1, 1]
    p_gen = pos_gen()
    out_on = next(p_gen)
    while True:
        n += 1
        if n == out_on:
            next_sign = sign.pop(0)
            if not sign:
                sign = [-next_sign] * 2
            yield -n, next_sign
            out_on = next(p_gen)
        else:
            yield 0

def part(n):
    "Partition numbers"
    p = [1]
    p_m = plus_minus()
    mods = []
    for _ in range(n):
        next_plus_minus = next(p_m)
        if next_plus_minus:
            mods.append(next_plus_minus)
        p.append(sum(p[offset] * sign for offset, sign in mods))
    return p[-1]

print("(Intermediaries):")
print("    posd:", list(islice(posd(), 10)))
print("    pos_gen:", list(islice(pos_gen(), 10)))
print("    plus_minus:", list(islice(plus_minus(), 15)))
print("\nPartitions:", [part(x) for x in range(15)])
