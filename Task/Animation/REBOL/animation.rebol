REBOL [
	Title: "Basic Animation"
	Author: oofoe
	Date: 2009-12-06
	URL: http://rosettacode.org/wiki/Basic_Animation
]

message: "Hello World! "  how: 1

roll: func [
	"Shifts a text string right or left by one character."
	text [string!] "Text to shift."
	direction [integer!] "Direction to shift -- right: 1, left: -1."
	/local h t
][
	either direction > 0 [
		h: last text  t: copy/part text ((length? text) - 1)
	][
		h: copy skip text 1  t: text/1
	]
	rejoin [h t]
]

; This next bit specifies the GUI panel. The window will have a
; gradient backdrop, over which will be composited the text, in a
; monospaced font with a drop-shadow. A timer (the 'rate' bit) is set
; to update 24 times per second. The 'engage' function in the 'feel'
; block listens for events on the text face. Time events update the
; animation and mouse-down change the animation's direction.

view layout [
	backdrop effect [gradient 0x1 coal black]

	vh1 as-is message ; 'as-is' prevents text trimming.
	font [name: font-fixed]
	rate 24
	feel [
		engage: func [f a e] [
			case [
				'time = a [set-face f message: roll message how] ; Animate.
				'down = a [how: how * -1] ; Change direction.
			]
		]
	]
]
