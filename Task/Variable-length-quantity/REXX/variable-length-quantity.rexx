/*REXX program to display (and also test/verify) some numbers as octets.*/
nums = x2d(200000)     x2d(1fffff)       2097172      2097151
#=words(nums)
say '  number     hex      octet    original'
say '═════════ ═════════ ═════════ ═════════'
ok=1
     do j=1  for #;      @.j=word(nums,j)
                      onum.j=octet(@.j)
                      orig.j=x2d(space(onum.j,0))

     say show(@.j)    show(d2x(@.j))    show(onum.j)   show(orig.j)
     if @.j\==orig.j  then ok=0
     end   /*j*/
say
if ok  then say 'All'    #    "numbers are OK."      /*all numbers  good*/
       else say 'Trouble right here in River City.'  /*some number ¬good*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────OCTET subroutine────────────────────*/
octet: procedure;  parse arg a,_       /*obtain  A from the passed arg. */
x=d2x(a)                               /*convert A to hexadecimal octet.*/
          do j=length(x)  by -2  to 1  /*process the "little" end first.*/
          _=substr(x,j-1,2,0) _        /*pad odd hexcharacters with ··· */
          end   /*j*/                  /*      ···  a zero on the left. */
return _
/*──────────────────────────────────SHOW subroutine─────────────────────*/
show:  return  center(arg(1),9)        /*justify via centering the text.*/
