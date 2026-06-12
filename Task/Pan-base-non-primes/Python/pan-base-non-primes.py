from sympy import isprime


def fmt_print(arr: list, limit=10):
    count = 1

    for item in arr:
        end = "\n" if count % 10 == 0 else " "
        count += 1

        print("%3d" % item, end=end)


def str_to_dec(s: str, b: int):
    res = 0

    for c in s:
        d = int(c)
        res = res * b + d

    return res


def main():
    limit = 2500
    pbnp = []

    for n in range(3, limit + 1):
        if n % 10 == 0 and n > 10:
            pbnp.append(n)
        else:
            comp = True

            for b in range(2, n):
                d = str_to_dec(str(n), b)
                if isprime(d):
                    comp = False
                    break

            if comp:
                pbnp.append(n)

    print("First 50 pan-base composites:")
    fmt_print(pbnp[:50])

    odd = list(filter(lambda x: x % 2 != 0, pbnp))

    print("\nFirst 20 odd pan-base composites:")
    fmt_print(odd[:20])

    tc = len(pbnp)

    print(f"\nCount of pan-base composites up to and including {limit}: {tc}")

    c = len(odd)

    print("Number odd = %3d or %9.6f" % (c, c / tc * 100), "%", sep="")

    c = tc - c

    print("Number even = %3d or %9.6f" % (c, c / tc * 100), "%", sep="")


if __name__ == "__main__":
    main()
