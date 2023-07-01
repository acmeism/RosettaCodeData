import urllib.request
import re

PLAUSIBILITY_RATIO = 2

def plausibility_check(comment, x, y):
    print('\n  Checking plausibility of: %s' % comment)
    if x > PLAUSIBILITY_RATIO * y:
        print('    PLAUSIBLE. As we have counts of %i vs %i, a ratio of %4.1f times'
              % (x, y, x / y))
    else:
        if x > y:
            print('    IMPLAUSIBLE. As although we have counts of %i vs %i, a ratio of %4.1f times does not make it plausible'
                  % (x, y, x / y))
        else:
            print('    IMPLAUSIBLE, probably contra-indicated. As we have counts of %i vs %i, a ratio of %4.1f times'
                  % (x, y, x / y))
    return x > PLAUSIBILITY_RATIO * y

def simple_stats(url='http://wiki.puzzlers.org/pub/wordlists/unixdict.txt'):
    words = urllib.request.urlopen(url).read().decode().lower().split()
    cie = len({word for word in words if 'cie' in word})
    cei = len({word for word in words if 'cei' in word})
    not_c_ie = len({word for word in words if re.search(r'(^ie|[^c]ie)', word)})
    not_c_ei = len({word for word in words if re.search(r'(^ei|[^c]ei)', word)})
    return cei, cie, not_c_ie, not_c_ei

def print_result(cei, cie, not_c_ie, not_c_ei):
    if ( plausibility_check('I before E when not preceded by C', not_c_ie, not_c_ei)
         & plausibility_check('E before I when preceded by C', cei, cie) ):
        print('\nOVERALL IT IS PLAUSIBLE!')
    else:
        print('\nOVERALL IT IS IMPLAUSIBLE!')
    print('(To be plausible, one count must exceed another by %i times)' % PLAUSIBILITY_RATIO)

print('Checking plausibility of "I before E except after C":')
print_result(*simple_stats())
