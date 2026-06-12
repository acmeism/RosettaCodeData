5000000 constant limit
create sieve limit allot

: prime? ( n -- ? ) sieve + c@ 0= ;
: notprime! ( n -- ) sieve + 1 swap c! ;

: prime_sieve
  sieve limit erase
  3
  begin
    dup dup * limit <
  while
    dup prime? if
      limit over dup * do
        i notprime!
      dup 2* +loop
    then
    2 +
  repeat
  drop ;

: digit_sum ( u -- u )
  dup 10 < if exit then
  10 /mod recurse + ;

: next_odd_prime ( u -- u )
  begin
    2 + dup prime?
  until ;

: next_honaker_prime ( u u -- u u )
  begin
    swap next_odd_prime swap 1+
    2dup digit_sum swap digit_sum =
  until ;

: print_pair ( u u -- )
  ." (" 3 .r ." , " 4 .r ." )" ;

: main
  prime_sieve
  ." First 50 Honaker primes (index, prime):" cr
  3 2 0   \ prime prime-index honaker-index
  begin
    dup 50 <
  while
    -rot next_honaker_prime
    2dup print_pair rot 1+
    dup 5 mod 0= if cr else space then
  repeat
  begin
    dup 10000 <
  while
    -rot next_honaker_prime rot 1+
  repeat
  drop
  cr ." Ten thousandth: " print_pair ;

main cr bye
