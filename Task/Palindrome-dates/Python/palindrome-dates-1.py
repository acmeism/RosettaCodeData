'''Palindrome dates'''

from datetime import datetime
from itertools import chain


# palinDay :: Int -> [ISO Date]
def palinDay(y):
    '''A possibly empty list containing the palindromic
       date for the given year, if such a date exists.
    '''
    s = str(y)
    r = s[::-1]
    iso = '-'.join([s, r[0:2], r[2:]])
    try:
        datetime.strptime(iso, '%Y-%m-%d')
        return [iso]
    except ValueError:
        return []


# --------------------------TEST---------------------------
# main :: IO ()
def main():
    '''Count and samples of palindromic dates [2021..9999]
    '''
    palinDates = list(chain.from_iterable(
        map(palinDay, range(2021, 10000))
    ))
    for x in [
            'Count of palindromic dates [2021..9999]:',
            len(palinDates),
            '\nFirst 15:',
            '\n'.join(palinDates[0:15]),
            '\nLast 15:',
            '\n'.join(palinDates[-15:])
    ]:
        print(x)


# MAIN ---
if __name__ == '__main__':
    main()
