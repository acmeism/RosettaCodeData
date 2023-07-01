import random

def count(w1,wnew):
    return sum(c1==c2 for c1,c2 in zip(w1, wnew))

def best_shuffle(w):
    wnew = list(w)
    n = len(w)
    rangelists = (list(range(n)), list(range(n)))
    for r in rangelists:
        random.shuffle(r)
    rangei, rangej = rangelists
    for i in rangei:
        for j in rangej:
            if i != j and wnew[j] != wnew[i] and w[i] != wnew[j] and w[j] != wnew[i]:
                wnew[j], wnew[i] = wnew[i], wnew[j]
                break
    wnew = ''.join(wnew)
    return wnew, count(w, wnew)


if __name__ == '__main__':
    test_words = ('tree abracadabra seesaw elk grrrrrr up a '
                  + 'antidisestablishmentarianism hounddogs').split()
    test_words += ['aardvarks are ant eaters', 'immediately', 'abba']
    for w in test_words:
        wnew, c = best_shuffle(w)
        print("%29s, %-29s ,(%i)" % (w, wnew, c))
