REBOL [
	Title: "Add Variables to Class at Runtime"
	Author: oofoe
	Date: 2009-12-04
	URL: http://rosettacode.org/wiki/Adding_variables_to_a_class_instance_at_runtime
]

; As I understand it, a REBOL object can only ever have whatever
; properties it was born with. However, this is somewhat offset by the
; fact that every instance can serve as a prototype for a new object
; that also has the new parameter you want to add.

; Here I create an empty instance of the base object (x), then add the
; new instance variable while creating a new object prototyped from
; x. I assign the new object to x, et voila', a dynamically added
; variable.

x: make object! [] ; Empty object.

x: make x [
	newvar: "forty-two" ; New property.
]

print "Empty object modifed with 'newvar' property:"
probe x

; A slightly more interesting example:

starfighter: make object! [
	model: "unknown"
	pilot: none
]
x-wing: make starfighter [
	model: "Incom T-65 X-wing"
]
	
squadron: reduce [
	make x-wing [pilot: "Luke Skywalker"]
	make x-wing [pilot: "Wedge Antilles"]
	make starfighter [
		model: "Slayn & Korpil B-wing"
		pilot: "General Salm"
	]
]

; Adding new property here.
squadron/1: make squadron/1 [deathstar-removal-expert: yes]

print [crlf "Fighter squadron:"]
foreach pilot squadron [probe pilot]
