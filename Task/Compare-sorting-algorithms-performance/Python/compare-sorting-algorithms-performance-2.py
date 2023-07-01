def ones(n):
    return [1]*n

def reversedrange(n):
    return reversed(range(n))

def shuffledrange(n):
    x = range(n)
    random.shuffle(x)
    return x
