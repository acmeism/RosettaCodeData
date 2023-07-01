from itertools import islice

class Recamans():
    "Recamán's sequence generator callable class"
    def __init__(self):
        self.a = None   # Set of results so far
        self.n = None   # n'th term (counting from zero)

    def __call__(self):
        "Recamán's sequence  generator"
        nxt = 0
        a, n = {nxt}, 0
        self.a = a
        self.n = n
        yield nxt
        while True:
            an1, n = nxt, n + 1
            nxt = an1 - n
            if nxt < 0 or nxt in a:
                nxt = an1 + n
            a.add(nxt)
            self.n = n
            yield nxt

if __name__ == '__main__':
    recamans = Recamans()
    print("First fifteen members of Recamans sequence:",
          list(islice(recamans(), 15)))

    so_far = set()
    for term in recamans():
        if term in so_far:
            print(f"First duplicate number in series is: a({recamans.n}) = {term}")
            break
        so_far.add(term)

    n = 1_000
    setn = set(range(n + 1))    # The target set of numbers to be covered
    for _ in recamans():
        if setn.issubset(recamans.a):
            print(f"Range 0 ..{n} is covered by terms up to a({recamans.n})")
            break
