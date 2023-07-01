def randomGenerator(seed=1):
    max_int32 = (1 << 31) - 1
    seed = seed & max_int32

    while True:
        seed = (seed * 214013 + 2531011) & max_int32
        yield seed >> 16

def deal(seed):
    nc = 52
    cards = list(range(nc - 1, -1, -1))
    rnd = randomGenerator(seed)
    for i, r in zip(range(nc), rnd):
        j = (nc - 1) - r % (nc - i)
        cards[i], cards[j] = cards[j], cards[i]
    return cards

def show(cards):
    l = ["A23456789TJQK"[int(c/4)] + "CDHS"[c%4] for c in cards]
    for i in range(0, len(cards), 8):
        print(" ".join(l[i : i+8]))

if __name__ == '__main__':
    from sys import argv
    seed = int(argv[1]) if len(argv) == 2 else 11982
    print("Hand {}".format(seed))
    deck = deal(seed)
    show(deck)
