REBOL [
	Title: "Graphical User Input"
	URL: http://rosettacode.org/wiki/User_Input_-_graphical
]

; Simple GUI's can be defined with 'layout', a special purpose dialect
; for specifying interfaces. In this case, I describe a gradient
; background with an instruction label, followed by the input fields
; and a validation button. It's possible to check dynamically as the
; user types but I wanted to keep this example as clear as possible.

view layout [

; You can define new widget styles. Here I create a padded label style
; (so that everything will line up) and a simple indicator light to
; show if there's a problem with an input field.

	style label vtext 60 "unlabeled"
	style indicator box maroon 24x24

	backdrop effect [gradient 0x1 black coal]

	vtext "Please enter a string, and the number 75000:"

; By default, GUI widgets are arranged top down. The 'across' word
; starts stacking widgets from left to right. 'return' starts a new
; line -- just like on a typewriter!

	across

; Notice I'm using my new label and indicator styles here. Widgets
; that I need to access later (the input field and the indicator) are
; assigned to variables.

	label "string:"  s: field 240  si: indicator  return

	label "number:"  n: field 50   ni: indicator  return

	pad 66
	button "validate" [

; The user may have entered bogus values, so I reset the indicators:

		si/color: ni/color: maroon

; Now I check to see if the values are correct. For the string, I just
; care that there is one. For the integer, I make sure that it
; evaluates to an integer and that it's value is 75000. Because I've
; already set the indicator colour, I don't care the integer
; conversion raises an error or not, so I ignore it if anything goes
; wrong.

		if 0 < length? get-face s [si/color: green]
		error? try [if 75000 = to-integer get-face n [ni/color: green]]

		show [si ni] ; Repainting multiple objects at once.
	]
]
