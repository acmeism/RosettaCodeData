REBOL [
    Title: "Keyboard Macros"
    URL: http://rosettacode.org/wiki/Keyboard_macros
]

; Application specific keyboard bindings using REBOL VID
; dialect. Implementation of the "Averageman" calculator --
; See http://www.atariarchives.org/bcc2/showpage.php?page=63 for details.

view layout [
	style btn button coal 46
	across

	display: h1 100 red maroon right ""  return

; Key shortcuts are specified as character arguments to widget
; descriptions in the layout.

	btn "1" #"1" [set-face display "1"]
	btn "+" #"+" [set-face display ""]
	return

	pad 54
	btn "=" #"=" [set-face display "3"]

	pad 1x100 return
	text "(c) 1977 G. Beker"
]
