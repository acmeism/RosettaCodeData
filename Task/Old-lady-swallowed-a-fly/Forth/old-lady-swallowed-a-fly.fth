: string, ( c-addr u -- ) \ store string at HERE , with a count
  dup c, here swap dup allot move ;

\ doubly linked list: (0|prev, 0|next, aside?, cstr animal; cstr aside)
\ aside? is true if the aside is always displayed.
variable swallowed
variable first
: >next ( swallow-addr -- swallow-addr' )
  cell+ @ ;
: >aside? ( swallow-addr -- f )
  2 cells + @ ;
: >animal ( swallow-addr -- c-addr u )
  3 cells + count ;
: >aside ( swallow-addr -- c-addr u )
  >animal + count ;

: swallow ( "animal" -- )
  align swallowed @ if here swallowed @ cell+ ! else here first ! then
  here swallowed @ , swallowed !
  0 , 0 , parse-word string, ; \ data structure still needs the aside
: always ( -- )  \ set aside? of last-defined swallow to true
  swallowed @ 2 cells + on ;
: aside ( "aside" -- )
  0 parse string, ;

swallow fly always aside But I don't know why she swallowed the fly,
swallow spider always aside That wriggled and jiggled and tickled inside her;
swallow bird aside Quite absurd, she swallowed the bird;
swallow cat aside Fancy that, she swallowed the cat;
swallow dog aside What a hog, she swallowed the dog;
swallow pig aside Her mouth was so big, she swallowed the pig;
swallow goat aside She just opened her throat, she swallowed the goat;
swallow cow aside I don't know how, she swallowed the cow;
swallow donkey aside It was rather wonky, she swallowed the donkey;

: ?aside ( swallow-addr -- )  \ print aside if aside? is true
  dup >aside? if >aside cr type else drop then ;

: reasons ( swallow-addr -- )  \ print reasons she swallowed something
  begin dup @ while
    dup cr ." She swallowed the " >animal type ."  to catch the "
    @ dup >animal type ." ," dup ?aside
  repeat drop ;

: verse ( swallow-addr -- )
  cr ." There was an old lady who swallowed a " dup >animal type ." ,"
  dup >aside cr type
  reasons
  cr ." Perhaps she'll die!" ;

: song ( -- )
  first @ begin dup verse cr >next dup 0= until drop
  cr ." There was an old lady who swallowed a horse..."
  cr ." She's dead, of course!" ;
