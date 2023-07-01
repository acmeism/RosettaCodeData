/*REXX program  demonstrates  the   Amd   operator,   choosing a  word  from each  set. */
               @.1 = "the     that      a"
               @.2 = "frog    elephant  thing"
               @.3 = "walked  treaded   grows"
               @.4 = "slowly  quickly"
               @.0 = 4                           /*define the number of sets being ised.*/
call Amb 1                                       /*find all word combinations that works*/
exit                                             /*stick a fork in it,  we're all done. */
/*--------------------------------------------------------------------------------------*/
Amb: procedure expose @.;   parse arg # x;     arg . u       /*ARG uppercases U value.  */
     if #>@.0  then do;  y= word(u, 1)                       /*Y:  is a  uppercased  U. */
                                       do n=2  to words(u);                ?= word(u, n)
                                       if left(?, 1) \== right(y, 1)  then return;    y= ?
                                       end   /*n*/
                         say strip(x)                        /*¬show superfluous blanks.*/
                    end
       do j=1  for words(@.#);  call Amb #+1 x word(@.#, j) /*gen all combos recursively*/
       end   /*j*/;             return
