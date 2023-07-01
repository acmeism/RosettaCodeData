Red [
	Title: "Biorythms"
	Source: https://rosettacode.org/wiki/Biorhythms#Red
	Purpose: "Calculates biorythmic values for given birthday and target date"
]

biorythms: function [
	"Calculates biorythmic values for given birthday and target date"
	bday	[date!]
	target	[date!]
][
	cycles: [
		"Physical day  " 23
		"Emotional day " 28
		"Mental day    " 33
	]

	quadrants: [
		["(up and rising" "peak"]
		["(up but falling" "transition"]
		["(down and falling" "valley"]
		["(down but rising" "transition"]
	]

		days:	target - bday

	print [
		#"^(line)"
		"Birthday   :" bday #"^(line)"
		"Target date:" target #"^(line)"
		"Days       :" days "days"
	]

	foreach [cycle len] cycles [
		posn:		days % len
		quadrant:	to-integer ((posn / len * 4) + 1)
		ampl:		to-percent round/to sin (days / len * 2 * pi) 0.01
		trend:		quadrants/(quadrant)
		case [
			ampl > 0.95				[desc: " Peak"]
			ampl < -0.95			[desc: " Valley"]
			(absolute ampl) <= 0.05	[desc: " Critical transition"]
			true [
				t: to-integer (quadrant / 4 * len) - posn
				desc: reduce [pad/left ampl 4 trend/(1) ", next" trend/(2) "in" t "days)"]
			]
		]
		print [cycle pad/left reduce [posn "of" len] 8 ":" desc]
	]
]

biorythms	1943-03-09	1972-07-11 ; Bobby Fisher won the World Chess Championship
biorythms	1987-05-22	2023-01-29 ; Novak Đoković won the Australian Open for the 11th time
biorythms	1969-01-03	2013-09-13 ; Michael Schuhmacher's bad skiing accident
