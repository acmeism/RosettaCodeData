USING: formatting io kernel math math.ranges present prettyprint
sequences sequences.extras sets ;

: dpal ( n -- seq )
    present all-subseqs members [ dup reverse = ] filter ;

! task 1
"Number  Palindromes" print
100 125 [a..b] [ dup pprint bl bl bl bl bl dpal .  ] each nl

! task 2
"Number                    Has no >= 2 digit-palindromes?" print
{ 9 169 12769 1238769 123498769 12346098769 1234572098769
  123456832098769 12345679432098769 1234567905432098769
  123456790165432098769 83071934127905179083
  1320267947849490361205695 }
[ dup dpal [ length 2 < ] reject empty? "%-25d %u\n" printf ]
each
