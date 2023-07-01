REBOL [
    Title: "Detect Divide by Zero"
    URL: http://rosettacode.org/wiki/Divide_by_Zero_Detection
]

; The 'try' word returns an error object if the operation fails for
; whatever reason. The 'error?' word detects an error object and
; 'disarm' keeps it from triggering so I can analyze it to print the
; appropriate message. Otherwise, any reference to the error object
; will stop the program.

div-check: func [
	"Attempt to divide two numbers, report result or errors as needed."
	x y
	/local result
] [
	either error? result: try [x / y][
		result: disarm result
		print ["Caught" result/type "error:" result/id]
	] [
		print [x "/" y "=" result]
	]
]

div-check 12 2       ; An ordinary calculation.
div-check 6 0        ; This will detect divide by zero.
div-check "7" 0.0001 ; Other errors can be caught as well.
