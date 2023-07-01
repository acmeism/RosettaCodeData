: .proper-divisors
  dup 1 ?do
    dup i mod 0= if i . then
  loop cr drop
;

: proper-divisors-count
  0 swap
  dup 1 ?do
    dup i mod 0= if swap 1 + swap then
  loop drop
;

: rosetta-proper-divisors
  cr
  11 1 do
    i . ." : " i .proper-divisors
  loop

  1 0
  20000 2 do
    i proper-divisors-count
    2dup < if nip nip i swap else drop then
  loop
  swap cr . ." has " . ." divisors" cr
;

rosetta-proper-divisors
