REBOL [
	Title: "Basic Input Loop"
	URL: http://rosettacode.org/wiki/Basic_input_loop
]

; Slurp the whole file in:
x: read %file.txt

; Bring the file in by lines:
x: read/lines %file.txt

; Read in first 10 lines:
x: read/lines/part %file.txt 10

; Read data a line at a time:
f: open/lines %file.txt
while [not tail? f][
	print f/1
	f: next f ; Advance to next line.
]
close f
