Red ["FizzBuzz"]

nmax: to-integer ask "Max number: "
while ["" <> trim rule: ask "New rule (empty to end): "][
	append rules: [] load rule
]
repeat n nmax [
	res: copy ""
	foreach [x blah] rules [
		if n % x = 0 [append res blah]
	]
	print either empty? res [n] [res]
]
halt
