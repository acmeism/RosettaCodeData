1 to: 100 do: [:i | |fb s|
	fb := {i isDivisibleBy: 3. i isDivisibleBy: 5. nil}.
	fb at: 3 put: (fb first | fb second) not.
	s := '<1?Fizz:><2?Buzz:><3?{1}:>' format: {i printString}.
	Transcript show: (s expandMacrosWithArguments: fb); cr].
