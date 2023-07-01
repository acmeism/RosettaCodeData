/*REXX program finds/displays the first perfect square with  N  unique digits in base N.*/
numeric digits 40                                /*ensure enough decimal digits for a #.*/
parse arg LO HI .                                /*obtain optional argument from the CL.*/
if LO==''            then do;  LO=2;  HI=16; end /*not specified?  Then use the default.*/
if LO==','           then      LO=2              /* "      "         "   "   "     "    */
if HI=='' | HI==","  then             HI=LO      /* "      "         "   "   "     "    */
@start= 1023456789abcdefghijklmnopqrstuvwxyz     /*contains the start # (up to base 36).*/
call base                                        /*initialize 2 arrays for BASE function*/
                                                 /* [↓]  find the smallest square with  */
    do j=LO  to HI;        beg= left(@start, j)  /*      N  unique digits in base  N.   */
       do k=iSqrt( base(beg,10,j) )  until #==0  /*start each search from smallest sqrt.*/
       $= base(k*k, j, 10)                       /*calculate square, convert to base J. */
       #= verify(beg, $)                         /*count differences between 2 numbers. */
       end   /*k*/
    say 'base'            right(j, length(HI) )                   "   root="   ,
                   lower( right( base(k, j, 10), max(5, HI) ) )   '   square='    lower($)
    end      /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
base: procedure expose !. !!.; arg x 1 #,toB,inB /*obtain:  three arguments.            */
      @= 0123456789abcdefghijklmnopqrstuvwxyz    /*the characters for the Latin alphabet*/
      if x==''  then do i=1  for length(@);   _= substr(@, i, 1);    m= i - 1;    !._= m
                     !!.m= substr(@, i, 1)
                     if i==length(@) then return /*Done with shortcuts?  Then go back.  */
                     end   /*i*/                 /* [↑]  assign shortcut radix values.  */
      if inb\==10  then                          /*only convert if  not  base 10.       */
         do 1;  #= 0                             /*result of converted  X  (in base 10).*/
         if inb==2   then do; #= b2d(x); leave; end  /*convert   binary    to decimal.  */
         if inb==16  then do; #= x2d(x); leave; end  /*   "    hexadecimal  "    "      */
           do j=1  for length(x)                 /*convert  X:   base inB  ──► base 10. */
           _= substr(x, j, 1);  #= # * inB + !._ /*build a new number,  digit by digit. */
           end    /*j*/                          /* [↑]  this also verifies digits.     */
         end
      y=                                         /*the value of  X  in base  B (so far).*/
      if tob==10  then return #                  /*if TOB is ten,  then simply return #.*/
      if tob==2   then return d2b(#)             /*convert base 10 number to binary.    */
      if tob==16  then return d2x(#)             /*   "      "   "    "    " hexadecimal*/
         do  while  # >= toB                     /*convert #:    base 10  ──►  base toB.*/
         _= # // toB;           y= !!._ || y     /*construct the output number.         */
         #= # % toB                              /*      ··· and whittle  #  down also. */
         end    /*while*/                        /* [↑]  algorithm may leave a residual.*/
      return !!.# || y                           /*prepend the residual, if any.        */
/*──────────────────────────────────────────────────────────────────────────────────────*/
iSqrt: procedure; parse arg x;  r=0;  q=1;             do while q<=x;  q=q*4;  end
        do while q>1; q=q%4; _=x-r-q; r=r%2; if _>=0 then do;x=_;r=r+q; end; end; return r
/*──────────────────────────────────────────────────────────────────────────────────────*/
b2d:   return x2d( b2x( arg(1) ) )               /*convert binary      number to decimal*/
d2b:   return x2b( d2x( arg(1) ) )  +  0         /*   "    hexadecimal    "    "    "   */
lower: @abc= 'abcdefghijklmnopqrstuvwxyz'; return translate(arg(1), @abc, translate(@abc))
