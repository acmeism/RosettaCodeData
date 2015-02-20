def sd1(numbers):
    if numbers:
        mean = sum(numbers) / len(numbers)
        sd = (sum((n - mean)**2 for n in numbers) / len(numbers))**0.5
        return sd, mean
    else:
        return 0, 0

def sd2(numbers):
    if numbers:
        sx = sxx = n = 0
        for x in numbers:
            sx += x
            sxx += x*x
            n += 1
        sd = (n * sxx - sx*sx)**0.5 / n
        return sd, sx / n
    else:
        return 0, 0

def histogram(numbers):
    h = [0] * 10
    maxwidth = 50 # characters
    for n in numbers:
        h[int(n*10)] += 1
    mx = max(h)
    print()
    for n, i in enumerate(h):
        print('%3.1f: %s' % (n / 10, '+' * int(i / mx * maxwidth)))
    print()

if __name__ == '__main__':
    import random
    for i in range(1, 6):
        n = [random.random() for j in range(10**i)]
        print("\n##\n## %i numbers\n##" % 10**i)
        print('  Naive  method: sd: %8.6f, mean: %8.6f' % sd1(n))
        print('  Second method: sd: %8.6f, mean: %8.6f' % sd2(n))
        histogram(n)
