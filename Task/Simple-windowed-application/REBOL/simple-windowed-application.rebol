REBOL [
	Title: "Simple Windowed Application"
	Author: oofoe
	Date: 2009-12-07
	URL: http://rosettacode.org/wiki/Simple_Windowed_Application
]

clicks: 0

; Simple GUI's in REBOL can be defined with 'layout', a
; special-purpose language (dialect, in REBOL-speak) for specifying
; interfaces. In the example below, I describe a gradient background
; with a text label and a button. The block in the button section
; details what should happen when it's clicked on -- increment the
; number of clicks and update the label text.

; The 'view' function paints the layout on the screen and listens for
; events.

view layout [
	backdrop effect [gradient 0x1 black coal]

	label: vtext "There have been no clicks yet."

	button maroon "click me" [
		clicks: clicks + 1
		set-face label reform ["clicks:" clicks]
	]
]
