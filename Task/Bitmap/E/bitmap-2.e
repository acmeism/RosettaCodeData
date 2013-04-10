? def i := makeImage(3, 3)
# value: [000000 000000 000000 ]
#        [000000 000000 000000 ]
#        [000000 000000 000000 ]
#

? i.fill(makeColor.fromFloat(1, 0, 0))
? i
# value: [ff0000 ff0000 ff0000 ]
#        [ff0000 ff0000 ff0000 ]
#        [ff0000 ff0000 ff0000 ]
#

? i[1, 1] := makeColor.fromFloat(0.5, 0.5, 0.5)
# value: 808080

? i
# value: [ff0000 ff0000 ff0000 ]
#        [ff0000 808080 ff0000 ]
#        [ff0000 ff0000 ff0000 ]
#

? i[0, 1]
# value: ff0000

? i[1, 1]
# value: 808080

? i.writePPM(<import:java.io.makeFileOutputStream>(<file:~/Desktop/Rosetta.ppm>))
