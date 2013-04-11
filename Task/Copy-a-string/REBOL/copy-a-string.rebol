REBOL [
    Title: "String Copy"
    Date: 2009-12-16
    Author: oofoe
    URL: http://rosettacode.org/wiki/Copy_a_string
]

x: y: "Testing."
y/2: #"X"
print ["Both variables reference same string:" mold x "," mold y]

x: "Slackeriffic!"
print ["Now reference different strings:" mold x "," mold y]

y: copy x        ; String copy here!
y/3: #"X"        ; Modify string.
print ["x copied to y, then modified:" mold x "," mold y]

y: copy/part x 7 ; Copy only the first part of y to x.
print ["Partial copy:" mold x "," mold y]

y: copy/part  skip x 2  3
print ["Partial copy from offset:" mold x "," mold y]
