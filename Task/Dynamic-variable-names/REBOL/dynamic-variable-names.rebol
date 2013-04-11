REBOL [
	Title: "Dynamic Variable Name"
	Author: oofoe
	Date: 2009-12-28
	URL: http://rosettacode.org/wiki/Dynamic_variable_names
]

; Here, I ask the user for a name, then convert it to a word and
; assign the value "Hello!" to it. To read this phrase, realize that
; REBOL collects terms from right to left, so "Hello!" is stored for
; future use, then the prompt string "Variable name? " is used as the
; argument to ask (prompts user for input). The result of ask is
; converted to a word so it can be an identifier, then the 'set' word
; accepts the new word and the string ("Hello!") to be assigned.

set  to-word  ask "Variable name? "  "Hello!"
