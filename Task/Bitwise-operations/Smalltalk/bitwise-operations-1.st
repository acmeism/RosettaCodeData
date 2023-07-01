| testBitFunc |
testBitFunc := [ :a :b |
     ('%1 and %2 is %3' % { a. b. (a bitAnd: b) }) displayNl.
     ('%1 or %2 is %3' % { a. b. (a bitOr: b) }) displayNl.
     ('%1 xor %2 is %3' % { a. b. (a bitXor: b) }) displayNl.
     ('not %1 is %2' % { a. (a bitInvert) }) displayNl.
     ('%1 left shift %2 is %3' % { a. b. (a bitShift: b) }) displayNl.
     ('%1 right shift %2 is %3' % { a. b. (a bitShift: (b negated)) }) displayNl.
 ].
testBitFunc value: 16r7F value: 4 .
