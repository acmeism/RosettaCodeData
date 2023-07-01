/*REXX pgm displays combination sets with repetitions for  X  things taken  Y  at a time*/
call RcombN    3,  2,  'iced jam plain'          /*The  1st  part of Rosetta Code task. */
call RcombN  -10,  3,  'Iced jam plain'          /* "   2nd    "   "    "      "    "   */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
RcombN: procedure; parse arg x,y,syms;  tell= x>0;  x=abs(x);   z=x+1  /*X>0? Show combo*/
        say copies('─',15) x "doughnut selection taken" y 'at a time:' /*display title. */
               do i=1  for words(syms);           $.i=word(syms, i)    /*assign symbols.*/
               end   /*i*/
        @.=1                                                           /*assign default.*/
               do #=1;        if tell    then  call show               /*display combos?*/
               @.y=@.y + 1;   if @.y==z  then  if .(y-1)  then leave   /* ◄─── recursive*/
               end   /*#*/
        say copies('═',15)  #  "combinations.";    say;   say          /*display answer.*/
        return
/*──────────────────────────────────────────────────────────────────────────────────────*/
.: procedure expose @. y z;   parse arg ?;     if ?==0  then return 1;            p=@.? +1
        if p==z  then return .(? -1);      do j=?  to y;   @.j=p;   end  /*j*/;   return 0
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:   L=;      do c=1  for y;   _=@.c;   L=L $._;   end  /*c*/;       say L;    return
