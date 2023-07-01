Red [Title: "Playing Cards"]

pip: ["a" "2" "3" "4" "5" "6" "7" "8" "9" "10" "j" "q" "k"]
suit: ["♣" "♦" "♥" "♠"]

make-deck: function [] [
	new-deck: make block! 52
	foreach s suit [foreach p pip [append/only new-deck reduce [p s]]]
	return new-deck
]

shuffle: function [deck [block!]] [deck: random deck]

deal: function [other-deck [block!] deck [block!]] [unless empty? deck [append/only other-deck take deck]]

contents: function [deck [block!]] [
	line: 0
	repeat i length? deck [
		prin [trim/all form deck/:i " "]
		if (to-integer i / 13) > line [line: line + 1 print ""]
]]

deck: shuffle make-deck
print "40 cards from a deck:"
loop 5 [ print "" loop 8 [prin [trim/all form take deck " "]]]
prin "^/^/remaining: "
contents deck
