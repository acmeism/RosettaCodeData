from fractions import Fraction

def muller_seq(n:int) -> float:
    seq = [Fraction(0), Fraction(2), Fraction(-4)]
    for i in range(3, n+1):
        next_value = (111 - 1130/seq[i-1]
            + 3000/(seq[i-1]*seq[i-2]))
        seq.append(next_value)
    return float(seq[n])

for n in [3, 4, 5, 6, 7, 8, 20, 30, 50, 100]:
    print("{:4d} -> {}".format(n, muller_seq(n)))
