/*REXX program finds the median of a vector (and displays vector,median)*/
/*────────vector────────── ───show vector─── ───────show result─────────*/
v='1 9 2 4'               ;  say 'vector=' v;  say 'median=' median(v);   say
v='3 1 4 1 5 9 7 6'       ;  say 'vector= 'v;  say 'median=' median(v);   say
v='3 4 1 -8.4 7.2 4 1 1.2';  say 'vector= 'v;  say 'median=' median(v);   say
v='-1.2345678e99 2.3e+700';  say 'vector= 'v;  say 'median=' median(v);   say

exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────MEDIAN subroutine───────────────────*/
median:  procedure;   parse arg x      /*obtain the   X   argument.     */
call makeArray x                       /*make into scalar array (faster)*/
call Esort                             /*(ESORT is an overkill for this)*/
m=@.0%2                                /*  %  is REXX integer division. */
n=m+1                                  /*N:   the next element after M. */
if @.0//2==1  then return @.n          /*(odd?)   //  is REXX remainder.*/
                   return (@.m+@.n)/2  /*process an even─element vector.*/
/*──────────────────────────────────MAKEARRAY subroutine────────────────*/
makeArray: procedure expose @.;  parse arg v;  @.0=words(v) /*make array*/
              do j=1  for @.0;   @.j=word(v,j);    end      /*j*/
return
/*──────────────────────────────────ESORT subroutine────────────────────*/
Esort: procedure expose @.;     h=@.0               /*@.0 =  # entries. */
        do  while  h>1;         h=h%2               /*cut entries by ½. */
           do i=1  for @.0-h;   j=i;      k=h+i     /*sort lower section*/
              do  while  @.k<@.j                    /* [↓]  swap while <*/
              parse value  @.j @.k  with  @.k @.j   /*swap two values.  */
              if h>=j  then leave                   /*leave  if  h≥j    */
              j=j-h;   k=k-h                        /*diminish J and K. */
              end   /*while @.k<@.j*/
           end      /*i*/
        end         /*while h>l*/
return                                      /*exchange sort is finished.*/
