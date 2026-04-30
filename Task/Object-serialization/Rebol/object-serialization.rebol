Rebol [
    title: "Rosetta code: Object serialization"
    file: %Object_serialization.r3
    url: https://rosettacode.org/wiki/Object_serialization
    needs: 2.7.0
]
; ----------------------------
; Define a base "class" Person
; ----------------------------
; In Rebol, `make object! [...]` creates an object with defined fields (and optionally functions).
; Here, Person has two properties: name (string) and age (integer).
Person: make object! [
    name: ""
    age: 0
]

; ------------------------------------------------
; "Inherit" a subclass Student from Person
; ------------------------------------------------
; Since Rebol doesn't have classical inheritance, `make Person [...]`
; makes a copy of the Person object and lets you add or override fields.
; Student adds an extra property: grade (e.g., "A", "B", etc.)
Student: make Person [
    grade: ""
]

; ------------------------------------------------
; Inherit another subclass Teacher from Person
; ------------------------------------------------
; Teacher adds an extra property: subject (teaching subject)
Teacher: make Person [
    subject: ""
]

; ----------------------------------
; Create specific instances of each
; ----------------------------------
; Values in brackets override default properties when creating the object.
john:  make Person  [name: "John"  age: 40]
sally: make Student [name: "Sally" age: 18 grade: "A"]
bob:   make Teacher [name: "Bob"   age: 50 subject: "Math"]

; ------------------------------------------------
; Print text in yellow (assuming ANSI color functions are set up)
; ------------------------------------------------
print "Original instances:"

; ------------------------------------------------
; `probe` prints the value in developer-readable format and returns it
; This is useful for quickly seeing object content
; ------------------------------------------------
probe john
probe sally
probe bob

; ------------------------------------------------
; Create a block containing all three objects
; `reduce` evaluates each word and inserts its value into the block
; ------------------------------------------------
objects: reduce [john sally bob]

; ------------------------------------------------
; Save all object data (including words, values, and types) to a file
; `save/all` preserves the complete object structure
; ------------------------------------------------
save/all %objects.dat objects

; ------------------------------------------------
; Show header for loaded instances
; ------------------------------------------------
print "Loaded instances:"

; ------------------------------------------------
; Load objects back from the file
; `load` reconstructs the original structures from the saved format
; ------------------------------------------------
read-objects: load %objects.dat

; ------------------------------------------------
; Iterate over loaded objects and display them
; ------------------------------------------------
foreach obj read-objects [
    probe obj
]
