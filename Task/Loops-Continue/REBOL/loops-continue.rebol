REBOL [
	Title: "Loop/Continue"
	URL: http://rosettacode.org/wiki/Loop/Continue
]

; REBOL does not provide a 'continue' word for loop constructs,
; however, you may not even miss it:

print "One liner (compare to ALGOL 68 solution):"
repeat i 10 [prin rejoin [i  either 0 = mod i 5 [crlf][", "]]]

print [crlf "Port of ADA solution:"]
for i 1 10 1 [
	prin i
	either 0 = mod i 5 [
		prin newline
	][
		prin ", "
	]
]
