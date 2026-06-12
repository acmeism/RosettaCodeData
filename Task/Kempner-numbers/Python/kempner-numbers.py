""" rosettacode.org/wiki/Kempner_numbers """

from sympy import factorint

# Generate factorials (1, 1, 2, 6, 24, ...)
fact = [1]
for k in range(1, 100):  # Generate enough factorials
    fact.append(fact[-1] * k)


def kempner(n: int) -> int:
    """ find kempner number n """
    if n < 2:
        return 1

    # Get prime factors and their counts as a dictionary
    factorization = factorint(n)

    for p, e in factorization.items():
        v = p ** e
        if p * p >= v:
            continue
        # Find first factorial divisible by v
        for i, f in enumerate(fact, start=1):
            if f % v == 0:
                factorization[p] = i // p
                break

    # Return maximum of prime * count found in above loop
    return max(p * e for p, e in factorization.items())


if __name__ == '__main__':
    # Print first fifty Kempner numbers
    print("First fifty Kempner numbers:")
    result = [kempner(j) for j in range(1, 51)]
    for j in range(0, 50, 10):
        print(" ".join(f"{x:3d}" for x in result[j:j+10]))

    print()
    # Print Kempner numbers for range 77135679311 to 77135679321
    for j in range(77135679311, 77135679322):
        print(f"S({j}) = {kempner(j)}")
