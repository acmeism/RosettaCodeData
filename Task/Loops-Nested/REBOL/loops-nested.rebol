REBOL [
	Title: "Loop/Nested"
	Author: oofoe
	Date: 2010-01-05
	URL: http://rosettacode.org/wiki/Loop/Nested
]

; Number formatting.
zeropad: func [pad n][
    n: to-string n  insert/dup n "0" (pad - length? n)  n]

; Initialize random number generator from current time.
random/seed now

; Create array and fill with random numbers, range 1..20.
soup: array [10 10]
repeat row soup [forall row [row/1: random 20]]

print "Loop break using state variable:"
done: no
for y 1 10 1 [
	for x 1 10 1 [
		prin rejoin [zeropad 2 soup/:x/:y  " "]
		if 20 = soup/:x/:y [done: yes  break]
	]
	prin crlf
	if done [break]
]

print [crlf "Loop break with catch/throw:"]
catch [
	for y 1 10 1 [
		for x 1 10 1 [
			prin rejoin [zeropad 2 soup/:x/:y  " "]
			if 20 = soup/:x/:y [throw 'done]
		]
		prin crlf
	]
]
prin crlf
