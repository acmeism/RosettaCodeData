Red ["i before e except after c"]

testlist: function [wordlist /wfreq] [
	cie: cei: ie: ei: 0
	if not wfreq [forall wordlist [insert wordlist: next wordlist 1]]
	foreach [word freq] wordlist [
		parse word [ some [
			"cie" (cie: cie + freq)	|
			"cei" (cei: cei + freq)	|
			"ie"  (ie: ie + freq)	|
			"ei"  (ei: ei + freq)	|
			skip
		]]
	]
	print rejoin [
	"i is before e " ie " times, and also " cie " times following c.^/"
	"i is after e " ei " times, and also " cei " times following c.^/"
	"Hence ^"i before e^" is " either a: 2 * ei < ie [""] ["not "] "plausible,^/"
	"while ^"except after c^" is " either b: 2 * cie < cei [""] ["not "] "plausible.^/"
	"Overall the rule is " either a and b [""] ["not "] "plausible."]
]

print "Results for unixdict.txt:"
testlist read/lines http://wiki.puzzlers.org/pub/wordlists/unixdict.txt

print "^/Results for British National Corpus:"
bnc: next read/lines %1_2_all_freq.txt
spaces: charset "^- "
bnclist: collect [ foreach w bnc [	
	if 3 = length? seq: split trim w spaces [
		keep seq/1 keep to-integer seq/3
]]]
testlist/wfreq bnclist
