from proper_divisors import proper_divs

def amicable(rangemax=20000):
    n2divsum = {n: sum(proper_divs(n)) for n in range(1, rangemax + 1)}
    for num, divsum in n2divsum.items():
        if num < divsum and divsum <= rangemax and n2divsum[divsum] == num:
            yield num, divsum

if __name__ == '__main__':
    for num, divsum in amicable():
        print('Amicable pair: %i and %i With proper divisors:\n    %r\n    %r'
              % (num, divsum, sorted(proper_divs(num)), sorted(proper_divs(divsum))))
