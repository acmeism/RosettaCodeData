from collections import defaultdict

n = 100
mods = [
    (3, 'Fizz'),
    (5, 'Buzz'),
]

def fizzbuzz(n=n, mods=mods):
    res = defaultdict(str)

    for num, name in mods:
        for i in range(num, n+1, num):
            res[i] += name

    return '\n'.join(res[i] or str(i) for i in range(1, n+1))


if __name__ == '__main__':
    n = int(input())

    mods = []
    while len(mods) != 3:   # for reading until EOF change 3 to -1
        try:
            line = input()
        except EOFError:
            break
        idx = line.find(' ')                        # preserves whitespace
        num, name = int(line[:idx]), line[idx+1:]   #   after the first space
        mods.append((num, name))    # preserves order and duplicate moduli

    print(fizzbuzz(n, mods))
