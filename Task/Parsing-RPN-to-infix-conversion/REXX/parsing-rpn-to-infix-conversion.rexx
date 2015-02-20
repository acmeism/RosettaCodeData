/*REXX program converts Reverse Polish Notation (RPN) ──► infix notation*/
showAction = 1                         /*  0  if no showActions wanted. */
         # = 0                         /*initialize stack pointer to 0. */
        oS = '+ - / * ^'               /*operator symbols.              */
        oP = '2 2 3 3 4'               /*operator priorities.           */
        oA = '◄ ◄ ◄ ◄ ►'               /*operator associations.         */
say  "infix: "   toInfix( "3 4 2 * 1 5 - 2 3 ^ ^ / +" )
say  "infix: "   toInfix( "1 2 + 3 4 + ^ 5 6 + ^" )     /* [↓]  Deutsch.*/
say  "infix: "   toInfix( "Mond Sterne Schlamm + * Feur Suppe * ^" )
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────────────────────────────────────────*/
pop:    pop=#;    #=#-1;                 return @.pop
push:   #=#+1;    @.#=arg(1);            return
/*──────────────────────────────────────────────────────────────────────*/
stack2str: $=;    do j=1  for #;         _ = @.j;      y=left(_,1)
                  if pos(' ', _)==0  then _ = '{'strip(substr(_, 2))"}"
                                     else _ =          substr(_, 2)
                  $=$  '{'strip(y _)"}"
                  end   /*j*/
return space($)
/*──────────────────────────────────────────────────────────────────────*/
toInfix: parse arg rpn;   say copies('─',80-1);    say 'RPN: '  space(rpn)

  do N=1  for words(RPN); ?=word(RPN,N) /*process each of the RPN tokens.*/
  if pos(?,oS)==0  then call push '¥' ? /*when in doubt, add a Yen to it.*/
                   else do;   g=pop();    gp=left(g, 1);    g=substr(g, 2)
                              h=pop();    hp=left(h, 1);    h=substr(h, 2)
                        tp=substr(oP,pos(?, oS),  1)
                        ta=substr(oA,pos(?, oS),  1)
                        if hp<tp  |  (hp==tp & ta=='►')  then h="("h")"
                        if gp<tp  |  (gp==tp & ta=='◄')  then g="("g")"
                        call  push   tp  ||  h  ?  g
                        end
   if showAction  then say   right(?,25)    "──►"    stack2str()
   end   /*N*/

return space(substr(pop(), 2))
