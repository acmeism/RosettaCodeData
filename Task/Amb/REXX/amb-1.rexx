/*REXX program demonstrates the   Amd   operator,  choosing a word from each set.       */
@.=;           @.1 = "the    that     a"
               @.2 = "frog   elephant thing"
               @.3 = "walked treaded  grows"
               @.4 = "slowly quickly"
call Amb 1                                       /*find all word combinations that works*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Amb: procedure expose @.;  parse arg # x;     arg . u        /*ARG uppercases U values. */
             do j=1  until @.j==''                           /*locate a null string.    */
             end   /*j*/
     t= j-1                                                  /*define number of sets.   */
     if #>t  then do;  y=word(u, 1)                          /*Y:  is a  uppercased U.  */
                                      do n=2  to words(u);       ?=word(u, n)
                                      if left(?, 1) \== right(y, 1)  then return;      y=?
                                      end   /*n*/
                       say space(x)                          /*¬show superfluous blanks.*/
                  end

           do k=1  for words(@.#);    call Amb   #+1   x   word(@.#, k)
           end   /*k*/                                       /* [↑]  generate all combs */
     return                                                  /*      recursively.       */
