/*REXX program  solves  a  riddle  of 5 sailors, a pile of coconuts, and a monkey.      */
parse arg L H .;        if L==''  then L= 5      /*L  not specified?   Then use default.*/
                        if H==''  then H= 6      /*H   "      "          "   "  default.*/
                                                 /*{Tars is an old name for sailors.}   */
       do n=L  to H                              /*traipse through a number of sailors. */
                      do $=0  while \valid(n, $) /*perform while not valid coconuts.    */
                      end   /*$*/
       say 'sailors='n           "  coconuts="$  /*display number of sailors & coconuts.*/
       end  /*n*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
valid: procedure;  parse arg n,nuts              /*obtain the number sailors & coconuts.*/
                 do k=n  by -1  for n            /*step through the possibilities.      */
                 if nuts//n \== 1  then return 0 /*Not one coconut left?   No solution. */
                 nuts=nuts  -  (1  +  nuts % n)  /*subtract number of coconuts from pile*/
                 end   /*k*/
       return (nuts \== 0)  &  \(nuts//n \== 0)  /*see if number coconuts>0 & remainder.*/
