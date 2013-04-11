REBOL [
	Title: "Stack"
	Author: oofoe
	Date: 2010-10-04
	URL: http://rosettacode.org/wiki/Stack
]

stack: make object! [
	data: copy []

	push: func [x][append data x]
	pop: func [/local x][x: last data  remove back tail data  x]
	empty: does [empty? data]

	peek: does [last data]
]

; Teeny Tiny Test Suite

assert: func [code][print [either do code ["  ok"]["FAIL"]  mold code]]

print "Simple integers:"
s: make stack []  s/push 1  s/push 2 ; Initialize.

assert [2 = s/peek]
assert [2 = s/pop]
assert [1 = s/pop]
assert [s/empty]

print [lf "Symbolic data on stack:"]
v: make stack [data: [this is a test]] ; Initialize on instance.

assert ['test = v/peek]
assert ['test = v/pop]
assert ['a = v/pop]
assert [not v/empty]
