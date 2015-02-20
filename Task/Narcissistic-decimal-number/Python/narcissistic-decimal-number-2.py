try:
    import psyco
    psyco.full()
except:
    pass

class Narcissistics:
    def __init__(self, max_len):
        self.max_len = max_len
        self.power = [0] * 10
        self.dsum = [0] * (max_len + 1)
        self.count = [0] * 10
        self.len = 0
        self.ord0 = ord('0')

    def check_perm(self, out = [0] * 10):
        for i in xrange(10):
            out[i] = 0

        s = str(self.dsum[0])
        for d in s:
            c = ord(d) - self.ord0
            out[c] += 1
            if out[c] > self.count[c]:
                return

        if len(s) == self.len:
            print self.dsum[0],

    def narc2(self, pos, d):
        if not pos:
            self.check_perm()
            return

        while True:
            self.dsum[pos - 1] = self.dsum[pos] + self.power[d]
            self.count[d] += 1
            self.narc2(pos - 1, d)
            self.count[d] -= 1
            if d == 0:
                break
            d -= 1

    def show(self, n):
        self.len = n
        for i in xrange(len(self.power)):
            self.power[i] = i ** n
        self.dsum[n] = 0
        print "length %d:" % n,
        self.narc2(n, 9)
        print

def main():
    narc = Narcissistics(14)
    for i in xrange(1, narc.max_len + 1):
        narc.show(i)

main()
