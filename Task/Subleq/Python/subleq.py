import sys

def subleq(a):
    i = 0
    try:
        while i >= 0:
            if a[i] == -1:
                a[a[i + 1]] = ord(sys.stdin.read(1))
            elif a[i + 1] == -1:
                print(chr(a[a[i]]), end="")
            else:
                a[a[i + 1]] -= a[a[i]]
                if a[a[i + 1]] <= 0:
                    i = a[i + 2]
                    continue
            i += 3
    except (ValueError, IndexError, KeyboardInterrupt):
        print("abort")
        print(a)

subleq([15, 17, -1, 17, -1, -1, 16, 1, -1, 16, 3, -1, 15, 15,
        0, 0, -1, 72, 101, 108, 108, 111, 44, 32, 119, 111,
        114, 108, 100, 33, 10, 0])
