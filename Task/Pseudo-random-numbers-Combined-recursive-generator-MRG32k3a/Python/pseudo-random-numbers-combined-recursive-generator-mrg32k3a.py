# Constants
a1 = [0, 1403580, -810728]
m1 = 2**32 - 209
#
a2 = [527612, 0, -1370589]
m2 = 2**32 - 22853
#
d = m1 + 1

class MRG32k3a():

    def __init__(self, seed_state=123):
        self.seed(seed_state)

    def seed(self, seed_state):
        assert 0 <seed_state < d, f"Out of Range 0 x < {d}"
        self.x1 = [seed_state, 0, 0]
        self.x2 = [seed_state, 0, 0]

    def next_int(self):
        "return random int in range 0..d"
        x1i = sum(aa * xx  for aa, xx in zip(a1, self.x1)) % m1
        x2i = sum(aa * xx  for aa, xx in zip(a2, self.x2)) % m2
        self.x1 = [x1i] + self.x1[:2]
        self.x2 = [x2i] + self.x2[:2]

        z = (x1i - x2i) % m1
        answer = (z + 1)

        return answer

    def  next_float(self):
        "return random float between 0 and 1"
        return self.next_int() / d


if __name__ == '__main__':
    random_gen = MRG32k3a()
    random_gen.seed(1234567)
    for i in range(5):
        print(random_gen.next_int())

    random_gen.seed(987654321)
    hist = {i:0 for i in range(5)}
    for i in range(100_000):
        hist[int(random_gen.next_float() *5)] += 1
    print(hist)
