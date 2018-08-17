REBOL [
	Title: "Flow Control"
	URL: http://rosettacode.org/wiki/Flow_Control_Structures
]

; return -- Return early from function (normally, functions return
; result of last evaluation).

hatefive: func [
	"Prints value unless it's the number 5."
	value "Value to print."
][
	if value = 5 [return "I hate five!"]
	print value
]

print "Function hatefive, with various values:"
hatefive 99
hatefive 13
hatefive 5
hatefive 3

; break -- Break out of current loop.

print [crlf "Loop to 10, but break out at five:"]
repeat i 10 [
	if i = 5 [break]
	print i
]

; catch/throw -- throw breaks out of a code block to enclosing catch.

print [crlf "Start to print two lines, but throw out after the first:"]
catch [
	print "First"
	throw "I'm done!"
	print "Second"
]

; Using named catch blocks, you can select which catcher you want when throwing.

print [crlf "Throw from inner code block, caught by outer:"]
catch/name [
	print "Outer catch block."
	catch/name [
		print "Inner catch block."
		throw/name "I'm done!" 'Johnson
		print "We never get here."
	] 'Clemens
	print "We never get here, either."
] 'Johnson

; try

div: func [
	"Divide first number by second."
	a b
	/local r "Result"
][
	if error? try [r: a / b] [r: "Error!"]
	r ; Functions return last value evaluated.
]

print [crlf "Report error on bad division:"]
print div 10 4
print div 10 2
print div 10 1
print div 10 0
