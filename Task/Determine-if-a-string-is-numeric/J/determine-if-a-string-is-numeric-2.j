   isNumeric '152'
1
   isNumeric '152 -3.1415926 Foo123'
1 1 0
   isNumeric '42 foo42 4.2e1 4200e-2 126r3 16b2a 42foo'
1 0 1 1 1 1 0
   isNumericScalar '152 -3.1415926 Foo123'
0
   sayIsNumericScalar '-3.1415926'
-3.1415926 represents a scalar numeric value.
