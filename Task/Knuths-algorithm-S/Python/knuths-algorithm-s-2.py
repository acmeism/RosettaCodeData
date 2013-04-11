class S_of_n_creator():
    def __init__(self, n):
        self.n = n
        self.i = 0
        self.sample = []

    def __call__(self, item):
        self.i += 1
        n, i, sample = self.n, self.i, self.sample
        if i <= n:
            # Keep first n items
            sample.append(item)
        elif randrange(i) < n:
            # Keep item
            sample[randrange(n)] = item
        return sample
