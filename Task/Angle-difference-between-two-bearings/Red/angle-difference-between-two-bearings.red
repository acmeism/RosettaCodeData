anglediff: func [b1 b2 /local r][
	r:  mod (b2 - b1) 360
	either r >= 180
	[ r - 360 ]
	[ r ]
]

b1: 180
b2: -180

test-list: [
	[20 45]
	[-45 45]
	[-85 90]
	[-95 90]
	[-45 125]
	[-45 145]
	[29.4803 -88.6381]
	[-78.3251 -159.036]
]

foreach test-case test-list [
	b1: test-case/1
	b2: test-case/2
	print [ "b1 : " b1 " b2 : " b2 "angle diff b2 - b1 : " (anglediff b1 b2)]
]
