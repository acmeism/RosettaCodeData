6 array (seed)                         \ holds the seed
6 array (gens)                         \ holds the generators
                                       \ set up constants
       0 (gens) 0 th !                 \ 1st generator
 1403580 (gens) 1 th !
 -810728 (gens) 2 th !
  527612 (gens) 3 th !                 \ 2nd generator
       0 (gens) 4 th !
-1370589 (gens) 5 th !

1 32 lshift   209 - value (m)          \ 1st generator constant
1 32 lshift 22853 - value (n)          \ 2nd generator constant
                                       ( n1 n2 -- n3)
: (mod) tuck mod tuck 0< if abs + ;then drop ;
: (generate) do (seed) i th @ (gens) i th @ * + loop swap (mod) ;
: (reseed) ?do (seed) i th ! loop ;    ( n1 n2 n3 limit index --)
: randomize 6 0 do dup i 3 mod if >zero then (seed) i th ! loop drop ;
                                       ( n --)
: random                               ( -- n)
  (m) 0 3 0 (generate) (n) 0 6 3 (generate) over over
  (seed) 4 th @ (seed) 3 th @ rot 6 3 (reseed)
  (seed) 1 th @ (seed) 0 th @ rot 3 0 (reseed) - (m) (mod) 1+
;

include lib/fp1.4th                    \ simple floating point support
include lib/zenfloor.4th               \ for FLOOR

5 array (count)                        \ setup an array of 5 elements

: test
  1234567 randomize
  random . cr random . cr random . cr
  random . cr random . cr cr           \ perform the first test

  987654321 randomize (m) 1+ s>f       \ set up denominator

  100000 0 ?do                         \ do this 100,000 times
    random s>f fover f/ 5 s>f f* floor f>s cells (count) + 1 swap +!
  loop fdrop
                                       \ show the results
  5 0 ?do i . ." : " (count) i th ? cr loop
;

test
