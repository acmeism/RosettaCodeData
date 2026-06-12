/*REXX program computes the  square root  by the old  "by pen─n'─paper"  (hand)  method.*/
signal on halt                                   /*handle the case of user interrupt.   */
parse arg xx digs .                              /*obtain optional arguments from the CL*/
if   xx=='' |   xx==","  then   xx=   2          /*Not specified?  Then use the default.*/
if digs=='' | digs==","  then digs= 500          /* "      "         "   "   "     "    */
numeric digits digs  +  digs % 2                 /*ensure enough decimal digits for calc*/
call sqrtHand xx, digs                           /*invoke the function for sqrt by hand.*/
halt:  say                                       /*pgm comes here for exact sqrt or HALT*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
iSqrt: procedure; parse arg z; q= 1;     r= 0;                 do while q<=z; q= q*4;  end
         do while q>1; q= q%4; _= z-r-q; r= r%2; if _>=0  then do; z= _; r= r+q;  end; end
       return r                                  /*R  is the integer square root of  Z. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
spit:  parse arg @;  call charout , @;  if #<9  then s= s  ||  @    /*show one character*/
       if @==.  then  do;  ##= ## + 1;  L= 0;   end;     return     /*handle dec. point.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrtHand: parse arg x 1 ox,##; parse value iSqrt(x) with j 1 k 1 ?  /*j, k, ? ≡ iSqrt(x)*/
          if ?==0   then ?=                              /*handle the case of sqrt < 1. */
          if j*j=x  then do;  say j;  return;       end  /*have we found the exact sqrt?*/
          L= length(?)                                   /*L:  used to place dec. point.*/
          if L==0   then do;  #= 0;   call spit .;  end  /*handle dec. point for X < 1. */
          s=                                             /*S:  partial square root.    .*/
                 do #=1  until #==##;        call spit ? /*spit out a single digit->term*/
                 if L>0  then call spit .                /*process the decimal point.   */
                 if #<9  then if datatype(s, 'N')  then if s*s=ox  then leave /*exact√ ?*/
                 if ?==''  then ?= 0                     /*ensure   ?  is a valid digit.*/
                 x= (x - k*?) * 100;  ?= 1
                 k= j * 20
                             do while ?<=10
                             if (k + ?)*? > x  then do;  ?= ? - 1;  leave;  end
                                               else      ?= ? + 1
                             end   /*while*/
                 j= ? + j*10
                 k= ? + k
                 end               /*#*/
          return
