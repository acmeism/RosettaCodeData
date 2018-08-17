REBOL [
	Title: "Inheritance"
	URL: http://rosettacode.org/wiki/Inheritance
]

; REBOL provides subclassing through its prototype mechanism:

Animal: make object! [
	legs: 4
]

Dog: make Animal [
	says: "Woof!"
]
Cat: make Animal [
	says: "Meow..."
]

Lab: make Dog []
Collie: make Dog []

; Demonstrate inherited properties:

print ["Cat has" Cat/legs "legs."]

print ["Lab says:" Lab/says]
