MASK64 = (1 << 64) - 1
C1 = 0x9e3779b97f4a7c15
C2 = 0xbf58476d1ce4e5b9
C3 = 0x94d049bb133111eb



class Splitmix64():

    def __init__(self, seed=0):
        self.state = seed & MASK64

    def seed(self, num):
        self.state =  num & MASK64

    def next_int(self):
        "return random int between 0 and 2**64"
        z = self.state = (self.state + C1) & MASK64
        z = ((z ^ (z >> 30)) * C2) & MASK64
        z = ((z ^ (z >> 27)) * C3) & MASK64
        answer = (z ^ (z >> 31)) & MASK64

        return answer

    def  next_float(self):
        "return random float between 0 and 1"
        return self.next_int() / (1 << 64)


if __name__ == '__main__':
    random_gen = Splitmix64()
    random_gen.seed(1234567)
    for i in range(5):
        print(random_gen.next_int())

    random_gen.seed(987654321)
    hist = {i:0 for i in range(5)}
    for i in range(100_000):
        hist[int(random_gen.next_float() *5)] += 1
    print(hist)
