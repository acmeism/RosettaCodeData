Red [
    Purpose: "Arabic <-> Roman numbers converter"
    Author: "Didier Cadieu"
    Date: "07-Oct-2016"
]

table-r2a: reverse [1000 "M" 900 "CM" 500 "D" 400 "CD" 100 "C" 90 "XC" 50 "L" 40 "XL" 10 "X" 9 "IX" 5 "V" 4 "IV" 1 "I"]

roman-to-arabic: func [r [string!] /local a b e] [
	a: 0
	parse r [any [b: ["I" ["V" | "X" | none] | "X" ["L" | "C" | none] | "C" ["D" | "M" | none] | "V" | "L" | "D" | "M"] e: (a: a + select table-r2a copy/part b e)]]
	a
]

; Example usage:
print roman-to-arabic "XXXIII"
print roman-to-arabic "MDCCCLXXXVIII"
print roman-to-arabic "MMXVI"
