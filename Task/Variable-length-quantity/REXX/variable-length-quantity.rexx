/*REXX program displays  (and also tests/verifies)  some numbers as  octets.            */
nums = x2d(200000)     x2d(1fffff)       2097172      2097151
#=words(nums)
say '  number       hex       octet    original'
say '══════════ ══════════ ══════════ ══════════'
ok=1
     do j=1  for #;      @.j= word(nums,j)
                      onum.j=octet(@.j)
                      orig.j=  x2d( space(onum.j, 0) )
     w=10
     say center(@.j, w)     center(d2x(@.j), w)     center(onum.j, w)    center(orig.j, w)
     if @.j\==orig.j  then ok=0
     end   /*j*/
say
if ok  then say 'All '   #    " numbers are OK." /*all  of the numbers are   good.      */
       else say "Some numbers are not OK."       /*some of the numbers are  ¬good.      */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
octet: procedure;  parse arg z,$                 /*obtain  Z  from the passed arguments.*/
       x=d2x(z)                                  /*convert Z  to a hexadecimal octet.   */
                   do j=length(x)  by -2  to 1   /*process the  "little"  end first.    */
                   $= substr(x, j-1, 2, 0)   $   /*pad odd hexadecimal characters with  */
                   end   /*j*/                   /*           ···  a zero on the left.  */
       return strip($)
