def pcg32(seed_state=None, seed_sequence=None, as_int=True):
    def next_int():
        "return random 32 bit unsigned int"
        nonlocal state, inc

        state, xorshifted, rot = (((state * CONST) + inc) & mask64,
                                  (((state >> 18) ^ state) >> 27) & mask32,
                                  (state >> 59) & mask32)
        answer = (((xorshifted >> rot) | (xorshifted << ((-rot) & 31)))
                  & mask32)
        return answer

    # Seed
    state = inc = 0
    if all(type(x) == int for x in (seed_state, seed_sequence)):
        inc = ((seed_sequence << 1) | 1) & mask64
        next_int()
        state += seed_state
        next_int()

    while True:
        yield next_int() if as_int else next_int() / (1 << 32)


if  __name__ == '__main__':
    from itertools import islice

    for i in islice(pcg32(42, 54), 5):
        print(i)
    hist = {i:0 for i in range(5)}
    for i in islice(pcg32(987654321, 1, as_int=False), 100_000):
        hist[int(i * 5)] += 1
    print(hist)
