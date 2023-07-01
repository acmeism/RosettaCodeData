let isLeapYear = System.DateTime.IsLeapYear
assert isLeapYear 1996
assert isLeapYear 2000
assert not (isLeapYear 2001)
assert not (isLeapYear 1900)
