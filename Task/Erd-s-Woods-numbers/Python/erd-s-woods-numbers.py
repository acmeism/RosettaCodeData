""" modified from https://codegolf.stackexchange.com/questions/230509/find-the-erd%C5%91s-woods-origin/ """

def erdős_woods(n):
    """ Returns the smallest value for `a` of the Erdős-Woods number n, or Inf if n is not in the sequence """
    primes = []
    P = k = 1
    while k < n:
        if P % k:
            primes.append(k)
        P *= k * k
        k += 1
    divs = [
        int(''.join(str((a%p==0) + 0) for p in primes)[::-1], 2)
        for a in range(n)
    ]
    np = len(primes)
    partitions = [(0, 0, 2**np-1)]
    for i in sorted(
        range(1,n),
        key = lambda x: bin(divs[x] | divs[n-x])[::-1].find('1'),
        reverse=True
    ):
        new_partitions = []
        factors = divs[i]
        other_factors = divs[n-i]
        for p in partitions:
            set_a, set_b, r_primes = p
            if factors & set_a or other_factors & set_b:
                new_partitions += (p,)
                continue
            for ix, v in enumerate(bin(factors & r_primes)[2:][::-1]):
                if v=='1':
                    w = 1 << ix
                    new_partitions += ((set_a^w, set_b, r_primes^w),)
            for ix, v in enumerate(bin(other_factors & r_primes)[2:][::-1]):
                if v=='1':
                    w = 1 << ix
                    new_partitions += ((set_a, set_b^w, r_primes^w),)
        partitions = new_partitions
    result = float('inf')
    for px, py, _ in partitions:
        x = y = 1
        for p in primes:
            if px % 2:
                x *= p
            if py % 2:
                y *= p
            px //= 2
            py //= 2
        result = min(result, n*pow(x,-1,y)%y*x-n)
    return result


K = 3
COUNT = 0
print('The first 20 Erdős–Woods numbers and their minimum interval start values are:')
while COUNT < 20:
    a = erdős_woods(K)
    if a != float('inf'):
        print(f"{K: 3d} -> {a}")
        COUNT += 1
    K += 1
