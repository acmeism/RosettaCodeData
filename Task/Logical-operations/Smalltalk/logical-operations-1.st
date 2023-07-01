|test|
test := [ :a :b |
  ('%1 %2 %3 = %4' % { a. 'and'. b. (a & b) }) displayNl.
  ('%1 %2 %3 = %4' % { a. 'or'. b. (a | b) }) displayNl.
  ('%1 %2 = %3' % {'not'. a. (a not) }) displayNl
].

test value: true value: true.
test value: false value: false.
test value: true value: false.
test value: false value: true.
