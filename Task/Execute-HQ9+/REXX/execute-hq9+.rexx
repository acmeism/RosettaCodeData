/*REXX program to implement the  HQ9+  language.*/         parse arg pgm .
accumulator=0
      do instructions=1  for length(pgm);     ?=substr(pgm,instructions,1)
        select
        when ?=='H' then say "hello, world"   /*this salutation varies. */
        when ?=='Q' then do j=1 for sourceline();  say sourceline(j);  end
        when ?== 9  then call 99
        when ?=='+' then accumulator=accumulator+1
        otherwise say 'invalid HQ9+ instruction:' ?
        end   /*select*/
      end     /*instructions*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────99 subroutine───────────────────────*/
99: do j=99 by -1 to 1
    say j 'bottle's(j) "of beer the wall,"
    say j 'bottle's(j) "of beer."
    say 'Take one down, pass it around,'
    n=j-1
    if n==0 then n='no'                           /*cheating to use  0. */
    say n 'bottle's(j-1) "of beer the wall."
    say
    end
say 'No more bottles of beer on the wall,'        /*finally, last verse.*/
say 'no more bottles of beer.'
say 'Go to the store and buy some more,'
say '99 bottles of beer on the wall.'
return
/*──────────────────────────────────S subroutine────────────────────────*/
s: if arg(1)==1 then return '';   return "s"      /*a simple pluralizer.*/
