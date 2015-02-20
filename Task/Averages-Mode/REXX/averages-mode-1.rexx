/*REXX program finds the   mode  (most occurring element)  of a vector. */
/*════════vector══════════   ═══show vector═══  ════show result══════   */
v= 1 8 6 0 1 9 4 6 1 9 9 9   ; say 'vector='v;   say 'mode='mode(v);   say
v= 1 2 3 4 5 6 7 8 9 11 10   ; say 'vector='v;   say 'mode='mode(v);   say
v= 8 8 8 2 2 2               ; say 'vector='v;   say 'mode='mode(v);   say
v='cat kat Cat emu emu Kat'  ; say 'vector='v;   say 'mode='mode(v);   say
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ESORT subroutine────────────────────*/
Esort: procedure expose @.;     h=@.0            /* [↓]  exchange sort. */
  do  while h>1;                h=h%2            /*%  is integer divide.*/
    do i=1  for @.0-h;   j=i;   k=h+i            /* [↓] perform exchange*/
      do  while @.k<@.j & h<j;  _=@.j;  @.j=@.k; @.k=_;  j=j-h; k=k-h; end
    end   /*i*/
  end     /*while h>1*/
return
/*──────────────────────────────────MODE subroutine─────────────────────*/
mode: procedure expose @.; parse arg x /*finds the  MODE  of a vector.  */
@.0=words(x)                           /* [↓] make an array from vector.*/
                       do k=1  for @.0;    @.k=word(x,k);    end  /*k*/
call Esort  @.0                        /*sort the elements in the array.*/
?=@.1                                  /*assume 1st element is the mode.*/
freq=1                                 /*the frequency of the occurrence*/
         do j=1  for @.0;     _=j-freq /*traipse through the elements.  */
         if @.j==@._  then do          /*this element same as previous? */
                           freq=freq+1 /*bump the frequency counter.    */
                           ?=@.j       /*this element is the mode,so far*/
                           end
         end   /*j*/
return ?                               /*return the node to the invoker.*/
