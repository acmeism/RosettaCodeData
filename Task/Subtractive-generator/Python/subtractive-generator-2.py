import collections

_ten2nine = 10**9

class Subtractive_generator():

    def __init__(self, seed=292929):
        self.r = collections.deque(maxlen=55)
        s = collections.deque(maxlen=55)
        s.extend([seed, 1])
        s.extend((s[n-2] - s[n-1]) % _ten2nine for n in range(2, 55))
        self.r.extend(s[(34 * (n+1)) % 55] for n in range(55))
        for n in range(219 - 54):
            self()

    def __call__(self):
        r = self.r
        r.append((r[0] - r[31]) % _ten2nine)
        return r[54]

if __name__ == '__main__':
    srand = Subtractive_generator()
    print([srand() for i in range(5)])
