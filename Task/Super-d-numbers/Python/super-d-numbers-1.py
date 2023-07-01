from itertools import islice, count

def superd(d):
    if d != int(d) or not 2 <= d <= 9:
        raise ValueError("argument must be integer from 2 to 9 inclusive")
    tofind = str(d) * d
    for n in count(2):
        if tofind in str(d * n ** d):
            yield n

if __name__ == '__main__':
    for d in range(2, 9):
        print(f"{d}:", ', '.join(str(n) for n in islice(superd(d), 10)))
