import itertools

def brent(f, x0):
    # main phase: search successive powers of two
    power = lam = 1
    tortoise = x0
    hare = f(x0)  # f(x0) is the element/node next to x0.
    while tortoise != hare:
        if power == lam:  # time to start a new power of two?
            tortoise = hare
            power *= 2
            lam = 0
        hare = f(hare)
        lam += 1

    # Find the position of the first repetition of length lam
    mu = 0
    tortoise = hare = x0
    for i in range(lam):
    # range(lam) produces a list with the values 0, 1, ... , lam-1
        hare = f(hare)
    # The distance between the hare and tortoise is now lam.

    # Next, the hare and tortoise move at same speed until they agree
    while tortoise != hare:
        tortoise = f(tortoise)
        hare = f(hare)
        mu += 1

    return lam, mu

def iterate(f, x0):
    while True:
        yield x0
        x0 = f(x0)

if __name__ == '__main__':
    f = lambda x: (x * x + 1) % 255
    x0 = 3
    lam, mu = brent(f, x0)
    print("Cycle length: %d" % lam)
    print("Cycle start index: %d" % mu)
    print("Cycle: %s" % list(itertools.islice(iterate(f, x0), mu, mu+lam)))
