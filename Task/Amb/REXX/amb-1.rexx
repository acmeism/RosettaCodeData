/*REXX program demonstrates the   Amd   operator,  choosing a word from each set.       */
@.=;           @.1 = "the that a"
               @.2 = "frog elephant thing"
               @.3 = "walked treaded grows"
               @.4 = "slowly quickly"
call Amb 1                                       /*find all word combinations that works*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Amb: procedure expose @.;  parse arg # x;  arg . u              /*2nd parse uppercases U*/
             do j=1  until @.j=='';   end                       /*locate a null string. */
     t=j-1                                                      /*define number of sets.*/
     if #>t  then do;  w=word(u,1)                              /*W:  is a  uppercased U*/
                                do n=2  to words(u);       ?=word(u, n)
                                if left(?, 1) \== right(w, 1)  then return;       w=?
                                end   /*n*/
                  say space(x)
                  end

             do k=1  for words(@.#)                             /*process words in sets.*/
             call Amb  #+1  x  word(@.#, k)                     /*generate combinations,*/
             end   /*k*/                                        /* [↑]    (recursively).*/
     return
