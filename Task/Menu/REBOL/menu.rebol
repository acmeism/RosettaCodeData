REBOL [
	Title: "Text Menu"
	Author: oofoe
	Date: 2009-12-08
	URL: http://rosettacode.org/wiki/Select
]

choices: ["fee fie" "huff and puff" "mirror mirror" "tick tock"]
choice: ""

valid?: func [
	choices [block! list! series!]
	choice
][
	if error? try [choice: to-integer choice] [return false]
	all [0 < choice  choice <= length? choices]
]

while [not valid? choices choice][
	repeat i length? choices [print ["  " i ":" choices/:i]]
	choice: ask "Which is from the three pigs? "
]
print ["You chose:" pick choices to-integer choice]
