/*REXX pgm calculates/displays base ten  long primes  (AKA golden primes, proper primes,*/
/*───────────────────── maximal period primes, long period primes, full reptend primes).*/
parse arg a                                      /*obtain optional argument from the CL.*/
if a='' | a=","  then a= '500 -500 -1000 -2000 -4000 -8000 -16000' ,  /*Not specified?  */
                         '-32000 -64000 -128000 -512000 -1024000'     /*Then use default*/
    do k=1  for words(a);     H=word(a, k)       /*step through the list of high limits.*/
    neg= H<1                                     /*used as an indicator to display count*/
    H= abs(H)                                    /*obtain the absolute value of  H.     */
    $=                                           /*the list of  long primes   (so far). */
       do j=7  to H  by 2                        /*start with 7,  just use odd integers.*/
       if .len(j) + 1 \== j  then iterate        /*Period length wrong?   Then skip it. */
       $=$ j                                     /*add the   long prime   to the $ list.*/
       end   /*j*/
    say
    if neg  then do;  say 'number of long primes ≤ '    H     " is: "     words($);    end
            else do;  say   'list of long primes ≤ '    H":";         say strip($);    end
    end      /*k*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
.len: procedure; parse arg x;  r=1;   do x;                   r= 10*r // x;     end  /*x*/
                              rr=r;   do p=1  until r==rr;    r= 10*r // x;     end  /*p*/
      return p
