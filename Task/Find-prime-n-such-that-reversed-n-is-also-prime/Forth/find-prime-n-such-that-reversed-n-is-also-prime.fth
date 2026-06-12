: prime? ( n -- ? ) here + c@ 0= ;
: not-prime! ( n -- ) here + 1 swap c! ;

: prime-sieve ( n -- )
  here over erase
  0 not-prime!
  1 not-prime!
  2
  begin
    2dup dup * >
  while
    dup prime? if
      2dup dup * do
        i not-prime!
      dup +loop
    then
    1+
  repeat
  2drop ;

: reverse ( n -- n )
  0 swap
  begin
    dup 0 >
  while
    10 /mod swap rot 10 * + swap
  repeat drop ;

: main
  1000 prime-sieve
  0
  500 1 do
    i prime? if i reverse prime? if
      1 +
      i 3 .r
      dup 10 mod 0= if cr else space then
    then then
  loop
  cr ." Count: " . cr ;

main
bye
