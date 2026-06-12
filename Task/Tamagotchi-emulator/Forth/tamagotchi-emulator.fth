( current object )
0 value o
' o >body constant 'o
: >o ( o -- ) postpone o postpone >r postpone 'o postpone ! ; immediate
: o> ( -- )   postpone r> postpone 'o postpone ! ; immediate

( chibi: classes with a current object and no formal methods )
0 constant object
: subclass ( class "name" -- a )  create here swap , does> @ ;
: class ( "name" -- a )  object subclass ;
: end-class ( a -- )  drop ;
: var ( a size "name" -- a )  over dup @ >r +!
  : postpone o r> postpone literal postpone + postpone ; ;

( tamagotchi )
class tama
  cell var hunger
  cell var boredom
  cell var age
  cell var hygiene
  cell var digestion
  cell var pooped
end-class

: offset ( -- )  \ go to column #13 of current line
  s\" \e[13G" type ;

: show ( "field" -- )
  ' POSTPONE literal POSTPONE dup
  POSTPONE cr POSTPONE id. POSTPONE offset
  POSTPONE execute POSTPONE ? ;  immediate
: dump ( -- )
  show hunger  show boredom  show age  show hygiene
  cr ." pooped" offset pooped @ if ." yes" else ." no" then ;

\ these words both exit their caller on success
: -poop ( -- )
  digestion @ 1 <> ?exit  digestion off  pooped on
  cr ." tama poops!"  r> drop ;
: -hunger ( -- )
  digestion @ 0 <> ?exit  hunger ++
  cr ." tama's stomach growls"  r> drop ;

: died-from ( 'reason' f -- )
  if cr ." tama died from " type cr bye then 2drop ;
: by-boredom ( -- )  "boredom"  boredom @ 5 > died-from ;
: by-sickness ( -- ) "sickness" hygiene @ 1 < died-from ;
: by-hunger ( -- )   "hunger"   hunger @  5 > died-from ;
: by-oldness ( -- )  "age"      age @    30 > died-from ;

: sicken ( -- )  pooped @ if hygiene -- then ;
: digest ( -- )  -poop -hunger  digestion -- ;
: die ( -- )     by-boredom  by-sickness  by-hunger  by-oldness ;

( tamagotchi ops )
: spawn ( -- )
  cr ." tama is born!"
  hunger off  boredom off  age off  pooped off
  5 hygiene !  5 digestion ! ;

: wait ( -- )
  cr ." ** time passes **"
  boredom ++  age ++
  digest sicken die ;

: look ( -- )  0
  boredom @ 2 > if 1+ cr ." tama looks bored" then
  hygiene @ 5 < if 1+ cr ." tama could use a wash" then
  hunger @  0 > if 1+ cr ." tama's stomach is grumbling" then
  age @    20 > if 1+ cr ." tama is getting long in the tooth" then
  pooped @      if 1+ cr ." tama is disgusted by its own waste" then
  0= if cr ." tama looks fine" then ;

: feed ( -- )
  hunger @ 0= if cr ." tama bats the offered food away" exit then
  cr ." tama happily devours the offered food"
  hunger off  5 digestion ! ;

: clean ( -- )
  pooped @ 0= if cr ." tama is clean enough already." exit then
  cr ." You dispose of the mess."  pooped off  5 hygiene ! ;

: play ( -- )
  boredom @ 0= if cr ." tama ignores you." exit then
  cr ." tama plays with you for a while."  boredom off ;

( game mode )
\ this just permanently sets the current object
\ a more complex game would use >o ... o> to set it
create pet  tama allot
pet to o

cr .( You have a pet tamagotchi!)
cr
cr .( commands:  WAIT LOOK FEED CLEAN PLAY)
cr  ( secret commands: SPAWN DUMP )
spawn look
cr
