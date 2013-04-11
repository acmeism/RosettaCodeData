import urllib.request
import re

PLAUSIBILITY_RATIO = 2

def plausibility_check(comment, x, y):
    print('\n  Checking plausibility of: %s' % comment)
    if x > PLAUSIBILITY_RATIO * y:
        print('    PLAUSIBLE. As we have counts of %i vs %i words, a ratio of %4.1f times'
              % (x, y, x / y))
    else:
        if x > y:
            print('    IMPLAUSIBLE. As although we have counts of %i vs %i words, a ratio of %4.1f times does not make it plausible'
                  % (x, y, x / y))
        else:
            print('    IMPLAUSIBLE, probably contra-indicated. As we have counts of %i vs %i words, a ratio of %4.1f times'
                  % (x, y, x / y))
    return x > PLAUSIBILITY_RATIO * y

words = set(urllib.request.urlopen(
    'http://www.puzzlers.org/pub/wordlists/unixdict.txt'
    ).read().decode().lower().split())
cie = sum('cie' in word for word in words)
cei = sum('cei' in word for word in words)
not_c_ie = sum(bool(re.search(r'(^ie|[^c]ie)', word)) for word in words)
not_c_ei = sum(bool(re.search(r'(^ei|[^c]ei)', word)) for word in words)

print('Checking plausibility of "I before E except after C":')
if ( plausibility_check('I before E when not preceded by C', not_c_ie, not_c_ei)
     and plausibility_check('E before I when preceded by C', cei, cie) ):
    print('\nOVERALL IT IS PLAUSIBLE!')
else:
    print('\nOVERALL IT IS IMPLAUSIBLE!')
print('\n(To be plausible, one word count must exceed another by %i times)' % PLAUSIBILITY_RATIO)
