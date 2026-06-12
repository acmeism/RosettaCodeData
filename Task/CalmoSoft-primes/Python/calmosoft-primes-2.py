""" rosettacode.org/wiki/CalmoSoft_primes """

from sympy import isprime, primerange


def calmo_prime_sequence(maxp):
    """ find the largest prime seq in primes < maxp that sums to a prime """
    pri = list(primerange(maxp))
    for win in range(len(pri)-1, 1, -1):  # window size
        psum = sum(pri[:win])
        for bot in range(-1, len(pri)-win):  # the last bottom of window
            if bot >= 0:
                psum -= pri[bot]
                psum += pri[win + bot]
            if isprime(psum):
                print('Longest Calmo prime seq (length', win,
                      ') of primes less than', maxp, 'totals', sum(pri[bot+1:bot+win+1]))
                if win > 24:
                    print('[', ', '.join(map(str, pri[bot+1:bot+7])), ', ... ',
                          ', '.join(map(str, pri[bot-5+win:bot+win+1])), ']\n', sep='')
                else:
                    print('The sequence is:', pri[bot+1:bot+win+1], '\n')
                return


for pmax in [100, 500_000, 50_000_000]:
    calmo_prime_sequence(pmax)
