\ Zeller's Congruence
: weekday ( d m y -- wd) \ 1 mon..7 sun
  over 3 < if 1- swap 12 + swap then
  100 /mod
  dup 4 / swap 2* -
  swap dup 4 / + +
  swap 1+ 13 5 */ + +
  ( in zeller 0=sat, so -2 to 0= mon, then mod, then 1+ for 1=mon)
  2- 7 mod 1+ ;

: yuletide
  ." December 25 is Sunday in "
  2122 2008 do
    25 12 i weekday
    7 = if i . then
  loop cr ;
