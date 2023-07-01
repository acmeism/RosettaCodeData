from random import gauss
from math import sqrt
from pprint import pprint as pp

NMAX=50

def statscreator():
    sum_ = sum2 = n = 0
    def stats(x):
        nonlocal sum_, sum2, n

        sum_ += x
        sum2 += x*x
        n    += 1.0
        return sum_/n, sqrt(sum2/n - sum_*sum_/n/n)
    return stats

def drop(target, sigma=1.0):
    'Drop ball at target'
    return gauss(target, sigma)

def deming(rule, nmax=NMAX):
    ''' Simulate Demings funnel in 1D. '''

    stats = statscreator()
    target = 0
    for i in range(nmax):
        value = drop(target)
        mean, sdev = stats(value)
        target = rule(target, value)
        if i == nmax - 1:
            return mean, sdev

def d1(target, value):
    ''' Keep Funnel over target. '''

    return target


def d2(target, value):
    ''' The new target starts at the center, 0,0 then is adjusted to
    be the previous target _minus_ the offset of the new drop from the
    previous target. '''

    return -value   # - (target - (target - value)) = - value

def d3(target, value):
    ''' The new target starts at the center, 0,0 then is adjusted to
    be the previous target _minus_ the offset of the new drop from the
    center, 0.0. '''

    return target - value

def d4(target, value):
    ''' (Dumb). The new target is where it last dropped. '''

    return value


def printit(rule, trials=5):
    print('\nDeming simulation. %i trials using rule %s:\n %s'
          % (trials, rule.__name__.upper(), rule.__doc__))
    for i in range(trials):
        print('    Mean: %7.3f, Sdev: %7.3f' % deming(rule))


if __name__ == '__main__':
    rcomments = [ (d1, 'Should have smallest deviations ~1.0, and be centered on 0.0'),
                  (d2, 'Should be centred on 0.0 with larger deviations than D1'),
                  (d3, 'Should be centred on 0.0 with larger deviations than D1'),
                  (d4, 'Center wanders all over the place, with deviations to match!'),
                ]
    for rule, comment in rcomments:
        printit(rule)
        print('  %s\n' % comment)
