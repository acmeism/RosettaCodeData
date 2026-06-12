USING: grouping io lists lists.lazy literals math math.primes
numspec prettyprint ;

<<
DIGIT: o 357
DIGIT: q 1379
DIGIT: e 2468
DIGIT: E 02468

NUMSPEC: one-odd-candidates o eq eEq ... ;
>>

CONSTANT: p $[ one-odd-candidates [ prime? ] lfilter ]

"Primes with one odd digit under 1,000:" print
p [ 1000 < ] lwhile list>array 9 group simple-table.

"\nCount of such primes under 1,000,000:" print
p [ 1,000,000 < ] lwhile llength .

"\nCount of such primes under 1,000,000,000:" print
p [ 1,000,000,000 < ] lwhile llength .
