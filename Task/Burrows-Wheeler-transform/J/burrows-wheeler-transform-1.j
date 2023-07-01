NB. articulate definition
NB. local names (assignment =.) won't pollute the namespace

3 :0'define Burrows-Wheeler transformations'
 Dyad=. [: :
 Monad=. :[:
 index=. i. Dyad
 Rank=. "
 sort=. /:~ Monad

 signal_error=. 13!:8
 VALUE_ERROR=.  21
 'STX ETX'=. 2 3 { a.
 verify=. ([ ('STX or ETX invalid in input' signal_error VALUE_ERROR + 0:))^:(1 e. (STX , ETX)&e.)
 rotations=. |."0 1~ -@:i.@:#
 tail=. {:
 mark=. STX , ,&ETX
 transform=. tail Rank 1 @: sort @: rotations @: mark @: verify
 EXPECT=. ETX , 'ANNB' , STX , 'AA'
 assert. EXPECT -: transform 'BANANA'

 unscramble=. (,Rank 0 1 sort)^:(#@[)&(i.0)
 find=. ETX index~ tail Rank 1
 from=. {
 behead=. }.
 curtail=. }:
 erase_mark =. behead @: curtail
 restore=.  erase_mark @: (from~ find) @: unscramble
 assert. 'BANANA' -: restore EXPECT

 obverse=. :.
 fixed=. f.
 bwt=: transform obverse restore fixed

 assert (-: ]&.:bwt)'same under transformation'

 EMPTY
)
