mask64 = (1 << 64) - 1
mask32 = (1 << 32) - 1
CONST = 6364136223846793005


class PCG32():

    def __init__(self, seed_state=None, seed_sequence=None):
        if all(type(x) == int for x in (seed_state, seed_sequence)):
            self.seed(seed_state, seed_sequence)
        else:
            self.state = self.inc = 0

    def seed(self, seed_state, seed_sequence):
        self.state = 0
        self.inc = ((seed_sequence << 1) | 1) & mask64
        self.next_int()
        self.state = (self.state + seed_state)
        self.next_int()

    def next_int(self):
        "return random 32 bit unsigned int"
        old = self.state
        self.state = ((old * CONST) + self.inc) & mask64
        xorshifted = (((old >> 18) ^ old) >> 27) & mask32
        rot = (old >> 59) & mask32
        answer = (xorshifted >> rot) | (xorshifted << ((-rot) & 31))
        answer = answer &mask32

        return answer

    def  next_float(self):
        "return random float between 0 and 1"
        return self.next_int() / (1 << 32)


if __name__ == '__main__':
    random_gen = PCG32()
    random_gen.seed(42, 54)
    for i in range(5):
        print(random_gen.next_int())

    random_gen.seed(987654321, 1)
    hist = {i:0 for i in range(5)}
    for i in range(100_000):
        hist[int(random_gen.next_float() *5)] += 1
    print(hist)
