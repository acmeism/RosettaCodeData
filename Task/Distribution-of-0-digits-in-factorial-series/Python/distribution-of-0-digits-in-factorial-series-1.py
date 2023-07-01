def facpropzeros(N, verbose = True):
    proportions = [0.0] * N
    fac, psum = 1, 0.0
    for i in range(N):
        fac *= i + 1
        d = list(str(fac))
        psum += sum(map(lambda x: x == '0', d)) / len(d)
        proportions[i] = psum / (i + 1)

    if verbose:
        print("The mean proportion of 0 in factorials from 1 to {} is {}.".format(N, psum / N))

    return proportions


for n in [100, 1000, 10000]:
    facpropzeros(n)

props = facpropzeros(47500, False)
n = (next(i for i in reversed(range(len(props))) if props[i] > 0.16))

print("The mean proportion dips permanently below 0.16 at {}.".format(n + 2))
