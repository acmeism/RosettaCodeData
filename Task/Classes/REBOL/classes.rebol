rebol [
    Title: "Classes"
    URL: http://rosettacode.org/wiki/Classes
]

; Objects are derived from the base 'object!' type. REBOL uses a
; prototyping object system, so any object can be treated as a class,
; from which to derive others.

cowboy: make object! [
	name: "Tex"  ; Instance variable.
	hi: does [   ; Method.
		print [self/name ": Howdy!"]]
]

; I create two instances of the 'cowboy' class.

tex: make cowboy []
roy: make cowboy [
	name: "Roy"  ; Override 'name' property.
]

print "Say 'hello', boys:"  tex/hi  roy/hi
print ""

; Now I'll subclass 'cowboy'. Subclassing looks a lot like instantiation:

legend: make cowboy [
	deed: "..."
	boast: does [
		print [self/name ": I once" self/deed "!"]]
]

; Instancing the legend:

pecos: make legend [name: "Pecos Bill"  deed: "lassoed a twister"]

print "Howdy, Pecos!"  pecos/hi
print "Tell us about yourself?"  pecos/boast
