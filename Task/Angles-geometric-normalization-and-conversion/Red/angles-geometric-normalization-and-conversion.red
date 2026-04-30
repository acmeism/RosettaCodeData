angle: object [
	;- internal value is stored in mil
	internal-value: none
	set-value: func [arg1 /turn /degre /gradian /mil /radian ]
	[
		if turn [
					if (arg1 < -1) or (arg1 > 1) [ cause-error 'user 'message "turn must be >= -1 and <= 1"]
					self/internal-value: (arg1 * 6400)
		]
		if degre [
			if (arg1 < -360) or ( arg1 > 360) [cause-error 'user 'message "degre must be >= -360 and <= 360"]
			self/internal-value: ( arg1 / 360 ) * 6400
		]
		if gradian [
			if (arg1 < -400) or (arg1 > 400) [cause-error 'user 'message "gradian must be >= -400 and <= 400"]
			self/internal-value: ((arg1 / 400) * 6400)
		]
		if mil [
			if (arg1 < -6400) or (arg1 > 6400) [ cause-error 'user 'message "mil must be >= -6400 and <= 6400"]
			self/internal-value: arg1
		]
		if radian [
			if  (arg1 < (-2 * pi) ) or (arg1 > (2 * pi)) [cause-error 'user 'message "radian must be >= -2*PI and <= 2*PI"]
			self/internal-value: ( arg1 * ( 1 / pi / 2) * 6400)
		]
	]
	get-value: func [ /turn /degre /gradian /mil /radian ]
		[
			if turn [
				return (self/internal-value / 6400)
			]
			if degre [
				return (self/internal-value / 6400 ) * 360
			]
			if gradian [
				return (( self/internal-value * 400) / 6400)
			]
			if mil [
				return self/internal-value
			]
			if radian [
				return (self/internal-value / ( ( 1 / pi / 2) * 6400))
			]
	]
]

;- test setters and getter
angle-turn: copy angle
angle-turn/set-value/turn 1
print angle-turn/get-value/turn

angle-degre: copy angle
angle-degre/set-value/degre 180
print angle-degre/get-value/degre

angle-gradian: copy angle
angle-gradian/set-value/gradian 100
print angle-gradian/get-value/gradian

angle-mil: copy angle
angle-mil/set-value/mil 10
print angle-mil/get-value/mil

angle-rad: copy angle
angle-rad/set-value/radian pi
print ( angle-rad/get-value/radian ) / pi

;- test normalization
angle-turn/set-value/turn -0.5
print angle-turn/get-value/turn

;-test conversions
print angle-turn/get-value/degre
print angle-turn/get-value/gradian
print angle-turn/get-value/mil
print (angle-turn/get-value/radian) / pi
