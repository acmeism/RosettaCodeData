from math import isqrt
from time import perf_counter

# numops = 0 # FOR TELEMETRY!!!!!

def countPrimes(limit):
#    global numops; numops = 0 # FOR TELEMETRY!!!!!

    # can't odd sieve for limit less than 3
    if limit < 3: return (0 if limit < 2 else 1)
    # `>> ` is used throughout for `// 2` for efficiency...

    # INITIALIZATION...

    rtlmt = isqrt(limit); rtlmtsz = (rtlmt + 1) // 2

    # note that roughs list starts at (and keeps) one to match the algorithm
    # though one is not a prime, but it is important in computation of pi and
    # that the roughs and pis lists are processed in sync...
    # roughs list of numbers culled of multiples of two here...
    roughs = [ i + i + 1 for i in range(rtlmtsz) ] # odds only; now two multiples!

    # phis for current roughs, thus init'ed to phip2 of each rough's pi;
    # these are the "stack" values for a recursive solution...
    phis = [ (limit // r + 1) // 2 for r in roughs ] # plus 1 for phi form!

    # List used to reference the "compressed" index of the pis list...
    phindxs = [ i for i in range(rtlmtsz) ] # plus one to get phis!

    # MAIN PARTIAL SIEVING LOOP...
    numbps = 0; rsz = rtlmtsz; bp = roughs[1] # starts with bp of 3
    while  bp * bp <= rtlmt:

        # mark all roughs culled in this base prime partial sieving pass...
        roughs[1] = 0 # make phi by eliminating bp as well!
        for cp in range(bp * bp, rtlmt, bp + bp): # cull points
            cpi = phindxs[cp >> 1]
            if roughs[cpi] == cp: roughs[cpi] = 0 # only if not alreay eliminated

        # MAIN INNER PROCESSING-SPLITTING LOOP...
        roi = 0
        for rii in range(rsz):
            m = roughs[rii]
            if not m: continue # skip marked!
            mbp = m * bp # odd product due to all roughs are odd!

            # crutial pis list updating based on size of `qbp` whether
            # less than or equal to or above `rtlmt`...
#            if mbp > rtlmt: numops += 1 # FOR TELEMETRY!!!!!
            phis[roi] = phis[rii] - \
                ( phis[phindxs[mbp >> 1]] if mbp <= rtlmt
                  # add one to make it phi form!...
                  else  phindxs[(limit // mbp - 1) >> 1] + 1 )

            roughs[roi] = m; roi += 1

        # update phindxs list to reflect new state of roughs; the only remaining
        # valid phindx values are those corresponding to current roughs...
        maxndxsz = rtlmtsz
        for ri in range(roi - 1, 0, -1):
            strti = roughs[ri] >> 1
            phindxs[strti:maxndxsz] = [ri] * (maxndxsz - strti); maxndxsz = strti

        bp = roughs[1]; rsz = roi; numbps += 1

    phi = phis[0] - sum(phis[1:rsz]) # accumulate result from pis

    # CALCULATION OF CONTRIBUTION DUE TO LARGE UNIQUE PRIME PAIRS...
    # All roughs values above one are now odd primes and above limit**(1/4) and
    # thus all products of unique pairs of these primes are odd and need to be
    # added (evens add; odds subtract - inclusion/exclusion principle)
    # as phi's to the result...
    phi += (rsz - 2) * (rsz - 1) // 2 # add all the "one"'s pairs calc may need!
    for p1i in range(1, rsz - 1):
        p1 = roughs[p1i]; qp1 = limit // p1
        endndx = phindxs[(qp1 // p1 - 1) >> 1]
        if endndx <= p1i: break
        for p2i in range(p1i + 1, endndx + 1):
#            numops += 1 # FOR TELEMETRY!!!!!
            phi += phindxs[(qp1 // roughs[p2i] - 1) >> 1]
        phi -= (endndx - p1i) * (p1i - 1) # efficient to remove what's not needed!

    numrtprms = numbps + rsz; return phi + numrtprms - 1

# USAGE...

for i in range(10): print(f"π(10**{i}) = {countPrimes(10**i):,}")

count = countPrimes(limit := 100_000_000_000) # get CPU up to speed!
start = perf_counter()
count = countPrimes(limit := 100_000_000_000)
stop = perf_counter()

# print(f"number of operations:  {numops:,}") # RESULT OF TELEMETRY!!!!!
print(f"\r\nFound {count:,} primes up to {limit:,}")
print(f"The above calculation took {stop - start:.3f} seconds.")
