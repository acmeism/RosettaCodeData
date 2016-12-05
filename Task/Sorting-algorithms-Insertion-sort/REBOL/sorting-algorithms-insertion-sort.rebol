; This program works with REBOL version R2 and R3, to make it work with Red
; change the word func to function
insertion-sort: func [
	a [block!]
	/local i [integer!] j [integer!] n [integer!]
	value [integer! string! date!]
][
	i: 2
	n: length? a

	while [i <= n][
        	value: a/:i
		j: i
		while [ all [ 	1 < j
				value < a/(j - 1) ]][
			
	       		a/:j: a/(j - 1)
			j: j - 1
        	]
        	a/:j: value
		i: i + 1
	]
	a
]

probe insertion-sort [4 2 1 6 9 3 8 7]

probe insertion-sort [ "---Monday's Child Is Fair of Face (by Mother Goose)---"
  "Monday's child is fair of face;"
  "Tuesday's child is full of grace;"
  "Wednesday's child is full of woe;"
 "Thursday's child has far to go;"
  "Friday's child is loving and giving;"
  "Saturday's child works hard for a living;"
  "But the child that is born on the Sabbath day"
  "Is blithe and bonny, good and gay."]

; just by adding the date! type to the local variable value the same function can sort dates.
probe insertion-sort [12-Jan-2015 11-Jan-2015 11-Jan-2016 12-Jan-2014]
