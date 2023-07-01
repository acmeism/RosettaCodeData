mask64 = (1 << 64) - 1
mask32 = (1 << 32) - 1
const = 0x2545F4914F6CDD1D



class Xorshift_star():

    def __init__(self, seed=0):
        self.state = seed & mask64

    def seed(self, num):
        self.state =  num & mask64

    def next_int(self):
        "return random int between 0 and 2**32"
        x = self.state
        x = (x ^ (x >> 12)) & mask64
        x = (x ^ (x << 25)) & mask64
        x = (x ^ (x >> 27)) & mask64
        self.state = x
        answer = (((x * const) & mask64) >> 32) & mask32
        return answer

    def  next_float(self):
        "return random float between 0 and 1"
        return self.next_int() / (1 << 32)


if __name__ == '__main__':
    random_gen = Xorshift_star()
    random_gen.seed(1234567)
    for i in range(5):
        print(random_gen.next_int())

    random_gen.seed(987654321)
    hist = {i:0 for i in range(5)}
    for i in range(100_000):
        hist[int(random_gen.next_float() *5)] += 1
    print(hist)
