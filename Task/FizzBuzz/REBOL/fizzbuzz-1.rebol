REBOL [
	Title: "FizzBuzz"
	Author: oofoe
	Date: 2009-12-10
	URL: http://rosettacode.org/wiki/FizzBuzz
]

; Concatenative. Note use of 'case/all' construct to evaluate all
; conditions. I use 'copy' to allocate a new string each time through
; the loop -- otherwise 'x' would get very long...

repeat i 100 [
	x: copy ""
	case/all [
		0 = mod i 3 [append x "Fizz"]
		0 = mod i 5 [append x "Buzz"]
		"" = x      [x: mold i]
	]
	print x
]
