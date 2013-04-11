REBOL [
	Title: "Abstract Type"
	Author: oofoe
	Date: 2009-12-05
	URL: http://rosettacode.org/wiki/Abstract_type
]

; The "shape" class is an abstract class -- it defines the "pen"
; property and "line" method, but "size" and "draw" are undefined and
; unimplemented.

shape: make object! [
	pen:  "X"
	size: none

	line: func [count][loop count [prin self/pen]  prin crlf]
	draw: does [none]
]

; The "box" class inherits from "shape" and provides the missing
; information for drawing boxes.

box: make shape [
	size: 10
	draw: does [loop self/size [line self/size]]
]

; "rectangle" also inherits from "shape", but handles the
; implementation very differently.

rectangle: make shape [
	size: 20x10
	draw: does [loop self/size/y [line self/size/x]]
]

; Unlike some languages discussed, REBOL has absolutely no qualms
; about instantiating an "abstract" class -- that's how I created the
; derived classes of "rectangle" and "box", after all.

s: make shape []  s/draw ; Nothing happens.

print "A box:"
b: make box [pen: "O" size: 5]  b/draw

print [crlf "A rectangle:"]
r: make rectangle [size: 32x5]  r/draw
