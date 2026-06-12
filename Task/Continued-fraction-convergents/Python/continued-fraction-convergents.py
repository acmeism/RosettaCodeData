#!/usr/bin/python3

def convergents(x, maxcount):
    epsilon = 1e-9
    components = []
    for _ in range(maxcount):
        ix = int(x)
        components.append(ix)
        fpart = x - ix
        if abs(fpart) < epsilon:
            break
        x = 1 / fpart

    numa, denoma = 1, 0
    numb, denomb = components[0], 1
    rationals = [f"{numb}/{denomb}" if denomb != 1 else f"{numb}"]
    for comp in components[1:]:
        numa, denoma, numb, denomb = numb, denomb, numa + comp * numb, denoma + comp * denomb
        rationals.append(f"{numb}/{denomb}" if denomb != 1 else f"{numb}")
    return rationals


if __name__ == "__main__":
    tests = [
        ("415/93", 415/93),
        ("649/200", 649/200),
        ("sqrt(2)", 2**0.5),
        ("sqrt(5)", 5**0.5),
        ("golden ratio", (5**0.5 + 1) / 2)
    ]

    print("The continued fraction convergents for the following (maximum 8 terms) are:")
    for s, x in tests:
        print(f"{s:>15} = {' '.join(convergents(x, 8))}")
