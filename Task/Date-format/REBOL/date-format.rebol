REBOL [
	Title: "Date Formatting"
	Author: oofoe
	Date: 2009-12-06
	URL: http://rosettacode.org/wiki/Date_format
]

; REBOL has no built-in pictured output.

zeropad: func [pad n][
    n: to-string n
    insert/dup n "0" (pad - length? n)
    n
]
d02: func [n][zeropad 2 n]

print now ; Native formatting.

print rejoin [now/year  "-"  d02 now/month  "-"  d02 now/day]

print rejoin [
	pick system/locale/days now/weekday ", "
	pick system/locale/months now/month " "
	now/day ", " now/year
]
