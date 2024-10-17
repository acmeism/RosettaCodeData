/*REXX pgm computes & shows a value grid of the Möbius function for a range of integers.*/
call time('r')
parse arg LO HI grp .                            /*obtain optional arguments from the CL*/
numeric digits 100
if  LO=='' |  LO==","  then  LO=   0             /*Not specified?  Then use the default.*/
if  HI=='' |  HI==","  then  HI= 199             /* "      "         "   "   "     "    */
if grp=='' | grp==","  then grp=  20             /* "      "         "   "   "     "    */
                                                 /*                            uuuuuuuuuuuu */
call genP HI                                     /*generate primes up to the  v  HI     */
say center(' The Moebius sequence from ' LO " --> " HI" ", max(50, grp*3), '=')   /*title*/
dd=''                                            /*variable holds output grid of GRP hhs.*/
    do j=LO  to  HI;  dd= dd right( moebius(j), 2) /*process some numbers from LO --> HI.*/
    if words(dd)==grp then do;  say substr(dd, 2); dd='' /*show grid if fully populated,*/
                           end                           /*  and nullify it for more hhs.*/
    end   /*j*/                                  /*for small grids, using wordCnt is OK.*/

if dd\=='' then say substr(dd, 2)                /*handle any residual numbers not shown*/
say format(time('e'),,3) 'seconds'
exit                                             /*stick a fork in it,  we're all done. */
/*--------------------------------------------------------------------------------------*/
moebius: procedure expose aa.; parse arg x       /*obtain a integer to be tested for mu.*/
        if x<1  then return '*'                  /*special? Then return symbol for null.*/
        hh= 0                                    /*start with a value of zero.          */
             do k=1;  p= aa.k                    /*get the  Kth  (pre-generated)  prime.*/
             if p>x  then leave                  /*prime (P)   > X?    Then we're done. */
             if p*p>x  then do;  hh= hh+1; leave /*prime (P**2 > X?   Bump hh and leave.*/
                            end
             if x//p==0  then do; hh= hh+1       /*X divisible by P?   Bump mu number.  */
                                  x= x % p       /*                    Divide by prime. */
                                  if x//p==0  then return 0  /*X÷by P?  Then return zero*/
                              end
             end   /*k*/                         /*hh (below) is almost always small, <9*/
        if hh//2==0 then return  1               /*Is hh even?  Then return postive  1  */
                         return -1               /* " "  odd?     "     "   negative 1. */
/*--------------------------------------------------------------------------------------*/
genP: aa.1=2; aa.2=3; aa.3=5; aa.4=7; aa.5=11; aa.6= 13; nP=6 /*assign low primes; hh primes.*/
                    do lim=nP  until lim*lim>=HI /*only keep primes up to the  sqrt(HI).*/
                    end   /*lim*/
       do j=aa.nP+4 by 2  to HI                  /*only find odd primes from here on.   */
       parse var j '' -1 uu;if uu==5 then iterate /*Is last digit a "5"?  Then not prime*/
       if j// 3==0  then iterate                 /*is J divisible by  3?    "   "    "  */
       if j// 7==0  then iterate                 /* " "     "      "  7?    "   "    "  */
       if j//11==0  then iterate                 /* " "     "      " 11?    "   "    "  */
       if j//13==0  then iterate                 /* " "     "      " 13?    "   "    "  */
                 do k=7  while k*k<=j            /*divide by some generated odd primes. */
                 if j // aa.k==0 then iterate j  /*Is J divisible by  P?  Then not prime*/
                 end   /*k*/                     /* [?]  a prime  (J)  has been found.  */
       nP= nP+1;    if nP<=HI  then aa.nP= j     /*bump prime count; assign prime to  aa.*/
       end      /*j*/;              return
