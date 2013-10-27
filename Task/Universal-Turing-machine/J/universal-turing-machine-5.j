   NB. Structured derivation of the universal Turing machine...

   o=. @:        NB. Composition of verbs (functions)
   c=. "_        NB. Constant verb (function)
   f=. &{::      NB. fetch
   e=. <@:       NB. enclose

   NB. utm (dyadic verb)...

   'Q S T P F B M PRINT MOVE C'=. i.10 NB. Using 10 boxes
     NB. Left:  Q     - Instruction table,  S - Turing machine state
     NB. Right: T     - Data tape,          P - Head position pointer,       F     - Display frequency
     NB. Local: B     - Blank defaults,     M - State and tape symbol read,  PRINT - Printing symbol
     NB.        MOVE  - Tape head moving instruction,                        C     - Step Counter

   DisplayTape=. > o (((48 + ]) { a.c)@[ ; ((] $ ' 'c) , '^'c))
   display=. ((((": o (]&:>) o (M f)) ,: (":@] C f)) ,. ':'c ) ,. (T f DisplayTape P f))
     NB. Displaying state, symbol, tape / step and pointer
   amend=. 0: (0 f)@]`(<@(1 f)@])`(2 f@])} ]

   NB. execute (monadic verb)...

   FillLeft=.  (_1   = P f      ) {:: B f      NB. Expanding and filling the tape
   FillRight=. ( P f = # o (T f)) {:: B f      NB. with 0's (if necessary)
   ia=. <@[ { ]                                NB. Selecting by the indices of an array

   e0=. (FillLeft , T f , FillRight)e T}]      NB. Adjusting the tape
   e1=. (P f + _1 = P f)e P}]                  NB. and the pointer (if necessary)
   e2=. (S f ; P f { T f)e M}]                 NB. Updating the state and reading the tape symbol
   e3=. [(smoutput o display)^:(0 = F f | C f) NB. Displaying intermediate cycles		       	
   e4=. (<"0 o (M f ia Q f)) (PRINT,MOVE,S)}]  NB. Performing the printing, moving and state actions
   e5=. (amend o ((PRINT,P,T)&{))e T}]         NB. Printing symbol on tape at the pointer position
   e6=. ((P f + MOVE f) ; 1 + C f) (P,C)}]     NB. Updating the pointer (and the counter)

   execute=. e6 o e5 o e4 o e3 o e2 o e1 o e0

   al=. &(] , (a: $~ [))                       NB. Appending local boxes
   cc=. 'A changeless cycle was detected!'c
   halt=. _1 c = S f                           NB. Halting when the current state is _1
   rt=. ((({. , ({: % 3:) , 3:) o $) $ ,) o (}."1) o (". ;. _2)
     NB. Reshaping the transition table as a 3D array (state,symbol,action)

   m0=. ,~                                     NB. Dyadic form (e.g., TPF f TuringMachine QS f )
   m1=. 5 al                                   NB. Appending 5 local boxes (B,M,PRINT,MOVE,C)
   m2=. ('' ; 0 c)e B}]                        NB. Initializing local B (empty defaults as 0)
   m3=. (0 ; rt o (Q f)) (C,Q)}]               NB. Setting (the counter and) the transition table
   m4=. execute^:(-. o halt)^:_                NB. Executing until a halt instruction is issued
   m5=. [smoutput o cc ^: (-. o halt)          NB. or a changeless single cycle is detected
   m6=. display                                NB. Displaying (returning) the final status

   utm=. m6 o m5 o m4 o m3 o m2 o m1 o m0 f.   NB. Fixing the universal Turing machine code

   lr=. 5!:5@< NB. Linear representation

   q: o $      o lr'utm'                       NB. The fixed tacit code length factors
2 2 3 71

   (12 71 $ ]) o lr'utm'                       NB. The fixed tacit code...
(((":@:(]&:>)@:(6&({::)) ,: (":@] 9&({::))) ,. ':'"_) ,. 2&({::) >@:(((
48 + ]) { a."_)@[ ; (] $ ' '"_) , '^'"_) 3&({::))@:([ (0 0 $ 1!:2&2)@:(
'A changeless cycle was detected!'"_)^:(-.@:(_1"_ = 1&({::))))@:((((3&(
{::) + 8&({::)) ; 1 + 9&({::)) 3 9} ])@:(<@:((0: 0&({::)@]`(<@(1&({::))
@])`(2&({::)@])} ])@:(7 3 2&{)) 2} ])@:(<"0@:(6&({::) (<@[ { ]) 0&({::)
) 7 8 1} ])@:([ (0 0 $ 1!:2&2)@:(((":@:(]&:>)@:(6&({::)) ,: (":@] 9&({:
:))) ,. ':'"_) ,. 2&({::) >@:(((48 + ]) { a."_)@[ ; (] $ ' '"_) , '^'"_
) 3&({::))^:(0 = 4&({::) | 9&({::)))@:(<@:(1&({::) ; 3&({::) { 2&({::))
 6} ])@:(<@:(3&({::) + _1 = 3&({::)) 3} ])@:(<@:(((_1 = 3&({::)) {:: 5&
({::)) , 2&({::) , (3&({::) = #@:(2&({::))) {:: 5&({::)) 2} ])^:(-.@:(_
1"_ = 1&({::)))^:_)@:((0 ; (({. , ({: % 3:) , 3:)@:$ $ ,)@:(}."1)@:(".;
._2)@:(0&({::))) 9 0} ])@:(<@:('' ; 0"_) 5} ])@:(5&(] , a: $~ [))@:(,~)
