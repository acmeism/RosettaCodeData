def f(x):
    return abs(x) ** 0.5 + 5 * x**3

def ask():
    return [float(y)
            for y in input('\n11 numbers: ').strip().split()[:11]]

if __name__ == '__main__':
    s = ask()
    s.reverse()
    for x in s:
        result = f(x)
        if result > 400:
            print(' %s:%s' % (x, "TOO LARGE!"), end='')
        else:
            print(' %s:%s' % (x, result), end='')
    print('')
