""" https://rosettacode.org/wiki/Earliest_difference_between_prime_gaps """

from primesieve import primes

LIMIT = 10**9
pri = primes(LIMIT * 5)
gapstarts = {}
for i in range(1, len(pri)):
    if pri[i] - pri[i - 1] not in gapstarts:
        gapstarts[pri[i] - pri[i - 1]] = pri[i - 1]

PM, GAP1, = 10, 2
while True:
    while GAP1 not in gapstarts:
        GAP1 += 2
    start1 = gapstarts[GAP1]
    GAP2 = GAP1 + 2
    if GAP2 not in gapstarts:
        GAP1 = GAP2 + 2
        continue
    start2 = gapstarts[GAP2]
    diff = abs(start2 - start1)
    if diff > PM:
        print(f"Earliest difference >{PM: ,} between adjacent prime gap starting primes:")
        print(f"Gap {GAP1} starts at{start1: ,}, gap {GAP2} starts at{start2: ,}, difference is{diff: ,}.\n")
        if PM == LIMIT:
            break
        PM *= 10
    else:
        GAP1 = GAP2
