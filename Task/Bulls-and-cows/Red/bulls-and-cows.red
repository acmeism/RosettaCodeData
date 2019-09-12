Red[]
a: "0123456789"
bulls: 0
random/seed now/time
number: copy/part random a 4
while [bulls <> 4] [
	bulls: 0
	cows: 0
	guess: ask "make a guess: "
	repeat i 4 [
		if (pick guess i) = (pick number i) [bulls: bulls + 1]
	]
	cows: (length? intersect guess number) - bulls
	print ["bulls: " bulls " cows: " cows]
]
print "You won!"
