identification division.
program-id. ninety-nine.
environment division.
data division.
working-storage section.
01	counter	pic 99.
	88 no-bottles-left value 0.
	88 one-bottle-left value 1.

01	parts-of-counter redefines counter.
	05	tens		pic 9.
	05	digits		pic 9.

01	after-ten-words.
	05	filler	pic x(7) value spaces.
	05	filler	pic x(7) value "Twenty".
	05	filler	pic x(7) value "Thirty".
	05	filler	pic x(7) value "Forty".
	05	filler	pic x(7) value "Fifty".
	05	filler	pic x(7) value "Sixty".
	05	filler	pic x(7) value "Seventy".
	05	filler	pic x(7) value "Eighty".
	05	filler	pic x(7) value "Ninety".
	05	filler	pic x(7) value spaces.

01	after-ten-array redefines after-ten-words.
	05	atens occurs 10 times pic x(7).

01	digit-words.
	05	filler	pic x(9) value "One".
	05	filler	pic x(9) value "Two".
	05	filler	pic x(9) value "Three".
	05	filler	pic x(9) value "Four".
	05	filler	pic x(9) value "Five".
	05	filler	pic x(9) value "Six".
	05	filler	pic x(9) value "Seven".
	05	filler	pic x(9) value "Eight".
	05	filler	pic x(9) value "Nine".
	05	filler	pic x(9) value "Ten".
	05	filler	pic x(9) value "Eleven".
	05	filler	pic x(9) value "Twelve".
	05	filler	pic x(9) value "Thirteen".
	05	filler	pic x(9) value "Fourteen".
	05	filler	pic x(9) value "Fifteen".
	05	filler	pic x(9) value "Sixteen".
	05	filler	pic x(9) value "Seventeen".
	05	filler	pic x(9) value "Eighteen".
	05	filler	pic x(9) value "Nineteen".
	05	filler	pic x(9) value spaces.

01	digit-array redefines digit-words.
	05	adigits occurs 20 times 	pic x(9).

01	number-name pic x(15).

01	stringified pic x(30).
01	outline		pic x(50).
01  other-numbers.
	03	n	pic 999.
	03	r	pic 999.
	
procedure division.
100-main section.
100-setup.
	perform varying counter from 99 by -1 until no-bottles-left
		move spaces to outline
		perform 100-show-number
		string stringified delimited by "|", space, "of beer on the wall" into outline end-string
		display outline end-display
		move spaces to outline
		string stringified delimited by "|", space, "of beer" into outline end-string
		display outline end-display
		move spaces to outline
		move "Take" to outline
		if one-bottle-left
			string outline delimited by space, space, "it" delimited by size, space, "|" into outline end-string
		else
			string outline delimited by space, space, "one" delimited by size, space, "|" into outline end-string
		end-if
		string outline delimited by "|", "down and pass it round" delimited by size into outline end-string
		display outline end-display
		move spaces to outline
		subtract 1 from counter giving counter end-subtract
		perform 100-show-number
		string stringified delimited by "|", space, "of beer on the wall" into outline end-string
		display outline end-display
		add 1 to counter giving counter end-add
		display space end-display
	end-perform.
	display "No more bottles of beer on the wall"
	display "No more bottles of beer"
	display "Go to the store and buy some more"
	display "Ninety-Nine bottles of beer on the wall"
	stop run.

100-show-number.
	if no-bottles-left
		move "No more|" to stringified
	else
		if counter < 20
			string function trim( adigits( counter ) ), "|" into stringified
		else
			if counter < 100
				move spaces to number-name
				string atens( tens ) delimited by space, space delimited by size, adigits( digits ) delimited by space into number-name end-string
				move function trim( number-name) to stringified
				divide counter by 10 giving n remainder r end-divide
				if r not = zero
					inspect stringified replacing first space by "-"
				end-if
				inspect stringified replacing first space by "|"
			end-if
		end-if
	end-if.
	if one-bottle-left
		string stringified delimited by "|", space, "bottle|" delimited by size into stringified end-string
	else
		string stringified delimited by "|", space, "bottles|" delimited by size into stringified end-string
	end-if.

100-end.
end-program.
