/*REXX program counts in octal until the number exceeds #pgm statements.*/
/*┌────────────────────────────────────────────────────────────────────┐
  │ Count all the protons  (and electrons!)  in the universe.          │
  │                                                                    │
  │ According to Sir Arthur Eddington in 1938 at his Tamer Lecture at  │
  │ Trinity College (Cambridge), he postulated that there are exactly  │
  │                                                                    │
  │                              136 ∙ 2^256                           │
  │                                                                    │
  │ protons in the universe,  and the same number of electrons,  which │
  │ is equal to around  1.57477e+79.                                   │
  │                                                                    │
  │ [Although, a modern estimate is around  10^80.]                    │
  └────────────────────────────────────────────────────────────────────┘*/
numeric digits 100000                  /*handle almost all big numbers. */
numIn=right('number in', 20)           /*used for indentation of output.*/
w=length(sourceline())                 /*used for formatting width of #s*/

  do #=0  to 136 * (2**256)            /*Sir Eddington, here we come !  */
  !=x2b( d2x(#) )
  _=right(!,  3 * (length(_) % 3 + 1),  0)
  o=
                do k=1  to length(_)  by 3
                o=o'0'substr(_,k,3)
                end   /*k*/

  say numIn 'base ten = ' right(#,w) numIn  "octal = " right(b2x(o)+0,w+w)
  if #>sourceline()  then leave        /*stop if #protons>pgm statements*/
  end   /*#*/
                                       /*stick a fork in it, we're done.*/
