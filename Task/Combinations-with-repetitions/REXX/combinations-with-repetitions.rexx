/*REXX program shows combination sets for  X  things taken  Y  at a time*/
parse arg x y symbols x2 y2 symbols2 . /*get optional arguments from CL.*/
if  x=='' |  x==','   then  x=  3      /*X  not specified?  Use default.*/
if  y=='' |  y==','   then  y=  2      /*Y   "     "         "      "   */
if x2=='' | x2==','   then x2=-10      /*X2  "     "         "      "   */
if y2=='' | y2==','   then y2=  3      /*Y2  "     "         "      "   */
if symbols ==''  then symbols ='iced jam plain'   /*symbol  table words.*/
if symbols2==''  then symbols2=symbols            /*symbol2   "     "   */
call  RcombN  x,  y,  symbols          /*1st part of Rosetta Code task. */
call  RcombN  x2, y2, symbols2         /*2nd   "   "    "      "    "   */
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────RCOMBN subroutine────────────────*/
RcombN: procedure;  parse arg x,y,syms;  tell=x>0;    x=abs(x);   base=x+1
syms=translate(syms,,',')              /*separate the symbols from list.*/
say "────────────"  abs(x)   'doughnut selection taken'   y   "at a time:"
           do i=1  for words(syms);  $.i=word(syms,i);  end
@.=1                                   /* [↓]   maybe show combinations.*/
           do #=1;  if tell  then do;  L=;     do d=1  for y   /*a comb.*/
                                               _=@.d;          L=L  $._
                                               end   /*d*/ ;        say L
                                  end
           @.y=@.y+1;    if @.y==base  then  if .RcombN(y-1)  then leave
           end   /*#*/
say "────────────"  #  'combinations.';             say;  say;  say
return #
.RcombN: procedure expose @. y base;  parse arg d;  if d==0  then return 1
p=@.d+1;   if p==base  then return .RcombN(d-1);    do u=d  to y;    @.u=p
                                                    end   /*u*/
return 0
