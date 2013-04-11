REBOL [
	Title: "Increment Numerical String"
	Author: oofoe
	Date: 2009-12-23
	URL: http://rosettacode.org/wiki/Increment_numerical_string
]

; Note the use of unusual characters in function name. Also note that
; because REBOL collects terms from right to left, I convert the
; string argument (s) to integer first, then add that result to one.

s++: func [s][to-string 1 + to-integer s]

; Examples. Because the 'print' word actually evaluates the block
; (it's effectively a 'reduce' that gets printed space separated),
; it's possible for me to assign the test string to 'x' and have it
; printed as a side effect. At the end, 'x' is available to submit to
; the 's++' function. I 'mold' the return value of s++ to make it
; obvious that it's still a string.

print [x: "-99" "plus one equals" mold s++ x]
print [x: "42" "plus one equals" mold s++ x]
print [x: "12345" "plus one equals" mold s++ x]
