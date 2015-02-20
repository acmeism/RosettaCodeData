#!/usr/bin/python3

'''
    Output:
    2013-Jan-27
    2013-Feb-24
    2013-Mar-31
    2013-Apr-28
    2013-May-26
    2013-Jun-30
    2013-Jul-28
    2013-Aug-25
    2013-Sep-29
    2013-Oct-27
    2013-Nov-24
    2013-Dec-29
'''

import sys
import calendar

YEAR = sys.argv[-1]
try:
    year = int(YEAR)
except:
    year = 2013
    YEAR = str(year)

c = calendar.Calendar(firstweekday = 0) # Sunday is day 6.

result = []
for month in range(0+1,12+1):
    MON = calendar.month_abbr[month]
    # list of weeks of tuples has too much structure
    # Use the overloaded list.__add__ operator to remove the week structure.
    flatter = sum(c.monthdays2calendar(year, month), [])
    # make a dictionary keyed by number of day of week,
    # successively overwriting values.
    SUNDAY = {b: a for (a, b) in flatter if a}[6]
    result.append('{}-{}-{:2}'.format(YEAR, MON, SUNDAY))

print('\n'.join(result))
