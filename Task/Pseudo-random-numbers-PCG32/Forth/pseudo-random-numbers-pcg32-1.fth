         4294967295 constant (32bit)
6364136223846793005 constant (n)
 377257722939173531 9223372036854775807 + 1+ value (s)
6502698458505894875 9223372036854775807 + 1+ value (i)

: pcg32int
  (s) dup >r (n) * (i) + to (s)
  r@ 18 rshift r@ xor 27 rshift (32bit) and
  r> 59 rshift (32bit) and
  over over invert 1+ 31 and lshift -rot
  rshift or (32bit) and
;

: pcg32seed
  0 to (s)
  1 lshift 1 or to (i)
  pcg32int drop
  +to (s)
  pcg32int drop
;

: pcg32float pcg32int s>f 1 32 lshift s>f f/ ;

create counts 5 cells allot

: tests
  cr 42 54 pcg32seed 5 0 do pcg32int . cr loop
  cr 5 0 ?do 0 counts i cells + ! loop

  987654321 1 pcg32seed
  100000 0 ?do
    1 pcg32float 5e f* floor f>s cells counts + +!
  loop

  5 0 ?do counts i dup ." [" 0 .r ." ] " cells + ? loop
;

tests
