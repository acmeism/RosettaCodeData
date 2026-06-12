USING: lexer math.parser prettyprint sequences sets ;

<< SYNTAX: PN: scan-token "_" without string>number suffix! ; >>

! permissive numbers
PN: _1_2_3_ .   ! 123
PN: 1__234___567 .   ! 1234567
PN: 0b0___10.100001p3 .   ! 20.125
