require random.fs
: d6 ( -- roll ) 6 random 1 + ;

variable smallest
: genstat ( -- stat )
   d6 dup smallest !
   3 0 do
     d6 dup smallest @ < if dup smallest ! then +
   loop
   smallest @ -
;

variable strong
variable total
: genstats ( -- cha wis int con dex str )
   0 strong !
   0 total !
   6 0 do
      genstat
      dup 15 >= if strong @ 1 + strong ! then
      dup total @ + total !
   loop
   total @ 75 < strong @ 2 < or if
     drop drop drop drop drop drop
     recurse
   then
;

: roll ( -- )
  genstats
  ." str:" .  ." dex:" .  ." con:" .
  ." int:" .  ." wis:" .  ." cha:" .
  ." (total:" total @ . 8 emit ." )"
;

utime drop seed !
