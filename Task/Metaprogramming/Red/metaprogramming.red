Red [ "Metaprogramming - Hinjolicious" ]

; This function will print a string as a heading and print any codes
; to the screen before executing it.
demo: function [s b] [print ["^/==" s "==^/"] print mold/only b do b]

demo "Infix Operators Creation" [
++: make op! function [a b][rejoin [a b]]
print "Hello" ++ ", " ++ "World" ++ "!"
]

demo "Runtime Code Evaluation" [
do load ask "Type your code: "
]

demo "Language Construct Redefinitions and Aliases" [
show: :print
show "Hello!"

if-else: :either
if-else (random 100) > 90 [
	show "You're lucky!"
][
	show "Try again!"
]
]

demo "Code Manipulation" [
; Create a C-Style for loop
for: function [ init[block!] cond[block!] next[block!] body[block!] ] [
	; Insert the next block to the end of body block
	body: head insert tail copy body next
	
	; Compose the block ready to be executed
	compose/deep [(init) while [(cond)] [(body)]]
]

do for [x: 1] [x <= 10] [x: x + 1] [
	print x
]

]
