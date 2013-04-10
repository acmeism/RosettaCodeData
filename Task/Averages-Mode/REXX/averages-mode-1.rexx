/*REXX program finds the   mode  (most occurring element)  of a vector. */

/*────────vector──────────   ───show vector───  ────show result──────   */
v='1 8 6 0 1 9 4 6 1 9 9 9'  ; say 'vector='v;   say 'mode='mode(v);   say
v='1 2 3 4 5 6 7 8 9 10 11'  ; say 'vector='v;   say 'mode='mode(v);   say
v='8 8 8 2 2 2'              ; say 'vector='v;   say 'mode='mode(v);   say
v='cat kat Cat emu emu Kat'  ; say 'vector='v;   say 'mode='mode(v);   say

exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────MAKEARRAY subroutine────────────────*/
makeArray: procedure expose @.; parse arg v;   @.0=words(v) /*make array*/
             do k=1 for @.0;    @.k=word(v,k); end   /*k*/
return
/*──────────────────────────────────ESORT subroutine────────────────────*/
esort: procedure expose @.;    h=@.0                    /*exchange sort.*/
 do while h>1;    h=h%2
  do i=1 for @.0-h;   j=i;   k=h+i
   do while @.k<@.j;t=@.j;@.j=@.k;@.k=t;if h>=j then leave;j=j-h;k=k-h;end
  end   /*i*/
 end    /*while h>1*/
return
/*──────────────────────────────────MODE subroutine─────────────────────*/
mode: procedure expose @.; parse arg x /*finds the  MODE  of a vector.  */
call makeArray x                       /*make an array out of the vector*/
call esort @.0                         /*sort the array elements.       */
?=@.1                                  /*assume 1st element is the mode.*/
freq=1                                 /*the frequency of the occurance.*/
          do j=1  for @.0;    _=j-freq
          if @.j==@._ then do
                           freq=freq+1 /*bump the frequency count.      */
                           ?=@.j       /*this is the one.               */
                           end
          end   /*j*/
return ?
