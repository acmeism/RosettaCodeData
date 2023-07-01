NB. Structured derivation of the universal Turing machine...

NB.--------------------------------------------------------------------------------------
NB. Quick and dirty tacit toolkit...

o=. @:
c=."_

ver=. (0:`)([:^:)

d=. (fix=. (;:'f.')ver) (train=.(;:'`:')ver&6) (an=. <@:((,'0') (,&<) ]))
ver=. (an f. o fix'ver')ver o an f.
z=. ((an'')`($ ,)`) (`:6)
d=. (a0=. `'') (a1=. (@:[) ((<'&')`) (`:6)) (a2=. (`(<(":0);_)) (`:6))
av=. ((an o fix'a0')`)  (`(an o fix'a1')) (`(an o fix'a2') ) (`:6)

Fetch=. (ver o train ;:'&{::')&.> o i. f.av
tie=. ver o train ;:'`'

indices=. (, $~ 1 -.~ $) o (train"0 o ((1 -: L.)S:1 # <S:1) o (tie&'') o fix :: ] @:[)
f=. ((ver o train ;:'&{')) o indices o train f.av

'A B'=. 2 Fetch
head=. (;:'<@:') {.~ 2 * 1 = # o [
h=. train o (indices o train o (A f) (head , (B f) o ] , < o an o [  , (;:'}]')c) ]) f.av

DropIfNB=. < o ('('"_ , ] , ')'"_) o ((}: ^: ('NB.' -: 3&{. o > o {:)) &. ;:)
pipe=. ([ , ' o ' , ])&:>/ o |.

is=. ". o (, o ": o > , '=. ' , pipe o (DropIfNB;._2) o ". o ('0 ( : 0)'c)) f.av

NB.--------------------------------------------------------------------------------------

NB. Producing the main (dyadic) verb utm...

Note 0
NB. X (boxed list)...
  Q     - Instruction table
  S     - Turing machine initial state

NB. Y (boxed list)...
  T     - Data tape
  P     - Head position pointer
  F     - Display frequency

NB. Local...
  B     - Blank defaults
  M     - State and tape symbol read
  PRINT - Printing symbol
  MOVE  - Tape head moving instruction
  C     - Step Counter
)

'Q S T P F B M PRINT MOVE C'=. 10 Fetch  NB. Fetching 10 Boxes

DisplayTape=. > o (((48 + ]) { a.c)@[ ; ((] $ ' 'c) , '^'c))
display=. ((((": o (]&:>) o M) ,: (":@] C)) ,. ':'c ) ,. (T DisplayTape P))
  NB. Displaying state, symbol, tape / step and pointer

amend=. 0 (0 {:: ])`(<@:(1 {:: ]))`(2 {:: ])} ]

NB. execute (monadic verb)...

FillLeft=.  (_1 = P    ) {:: B        NB. Expanding and filling the tape
FillRight=. ( P = # o T) {:: B        NB. with 0's (if necessary)
ia=. <@[ { ]                          NB. Selecting by the indices of an array

execute is
  T`(FillLeft , T , FillRight)h       NB. Adjusting the tape
  P`(P + _1 = P)                 h    NB. and the pointer (if necessary)
  M`(S ; P { T)                  h    NB. Updating the state and reading the tape symbol
  [ (smoutput o display)^:(0 = F | C) NB. Displaying intermediate cycles		       		
  (PRINT MOVE S)`(<"0 o (M ia Q))h    NB. Performing the printing, moving and state actions
  T`(amend o ((PRINT P T)f))     h    NB. Printing symbol on tape at the pointer position
  (P C)`((P + MOVE) ; 1 + C)     h    NB. Updating the pointer and the counter
)

cc=. 'A changeless cycle was detected!'c
halt=. _1 c = S                        NB. Halting when the current state is _1
rt=. ((({. , ({: % 3:) , 3:) o $) $ ,) o (}."1) o (". ;. _2)
  NB. Reshaping the transition table as a 3D array (state,symbol,action)

utm is  NB. Universal Turing Machine (dyadic verb)
  ,~                                  NB. Appending the arguments in reverse order
  ,&(;:5$',')                         NB. Appending 5 local boxes (B M PRINT MOVE C)
  B`('' ; 0 c)      h                 NB. Setting empty blank defaults as 0
  (C Q)`(0 ; rt o Q)h                 NB. Setting the counter and the transition table
  execute^:(-. o halt)^:_             NB. Executing until a halt instruction is issued
  [ smoutput o cc ^: (-. o halt)      NB. or a changeless single cycle is detected
  display                             NB. Displaying (returning) the final status
)

utm=. utm f.   NB. Fixing the universal Turing machine code

NB. The simulation code is produced by  77 (-@:[ ]\ 5!:5@<@:]) 'utm'
