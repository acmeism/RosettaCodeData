REBOL [
	Title: "Trigonometric Functions"
	URL: http://rosettacode.org/wiki/Trigonometric_Functions
]

radians: pi / 4  degrees: 45.0

; Unlike most languages, REBOL's trig functions work in degrees unless
; you specify differently.

print [sine/radians radians     sine degrees]
print [cosine/radians radians   cosine degrees]
print [tangent/radians radians  tangent degrees]

d2r: func [
	"Convert degrees to radians."
	d [number!] "Degrees"
][d * pi / 180]

arcsin: arcsine sine degrees
print [d2r arcsin  arcsin]

arccos: arccosine cosine degrees
print [d2r arccos  arccos]

arctan: arctangent tangent degrees
print [d2r arctan  arctan]
