Option Explicit

function dice5
	dice5 = int(rnd*5) + 1
end function

function dice7
	dim j
	do
		j = 5 * dice5 + dice5 - 6
	loop until j < 21
	dice7 = j mod 7 + 1
end function
