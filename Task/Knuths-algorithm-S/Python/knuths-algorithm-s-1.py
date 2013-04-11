from random import randrange

def s_of_n_creator(n):
    sample, i = [], 0
    def s_of_n(item):
        nonlocal i

        i += 1
        if i <= n:
            # Keep first n items
            sample.append(item)
        elif randrange(i) < n:
            # Keep item
            sample[randrange(n)] = item
        return sample
    return s_of_n

if __name__ == '__main__':
    bin = [0]* 10
    items = range(10)
    print("Single run samples for n = 3:")
    s_of_n = s_of_n_creator(3)
    for item in items:
        sample = s_of_n(item)
        print("  Item: %i -> sample: %s" % (item, sample))
    #
    for trial in range(100000):
        s_of_n = s_of_n_creator(3)
        for item in items:
            sample = s_of_n(item)
        for s in sample:
            bin[s] += 1
    print("\nTest item frequencies for 100000 runs:\n ",
          '\n  '.join("%i:%i" % x for x in enumerate(bin)))
