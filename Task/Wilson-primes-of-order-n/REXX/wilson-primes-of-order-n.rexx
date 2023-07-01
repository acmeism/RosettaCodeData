/*REXX program finds and displays Wilson primes:  a prime   P   such that  P**2 divides:*/
/*────────────────── (n-1)! * (P-n)!  -  (-1)**n   where  n  is 1 ──◄ 11,   and  P < 18.*/
parse arg oLO oHI hip .                          /*obtain optional argument from the CL.*/
if  oLO=='' |  oLO==","  then  oLO=      1       /*Not specified?  Then use the default.*/
if  oHI=='' |  oHI==","  then  oHI=     11       /* "      "         "   "   "     "    */
if  hip=='' |  hip==","  then  hip=  11000       /* "      "         "   "   "     "    */
call genP                                        /*build array of semaphores for primes.*/
!!.= .                                           /*define the  default  for factorials. */
bignum= !(hip)                                   /*calculate a ginormous factorial prod.*/
parse value bignum 'E0' with ex 'E' ex .         /*obtain possible exponent of factorial*/
numeric digits (max(9, ex+2) )                   /*calculate max # of dec. digits needed*/
call facts hip                                   /*go & calculate a number of factorials*/
title= ' Wilson primes  P  of order '  oLO " ──► " oHI',  where  P < '  commas(hip)
w= length(title) + 1                             /*width of columns of possible numbers.*/
say ' order │'center(title, w     )
say '───────┼'center(""   , w, '─')
      do n=oLO  to oHI;  nf= !(n-1)              /*precalculate a factorial product.    */
      z= -1**n                                   /*     "       " plus or minus (+1│-1).*/
      if n==1   then lim= 103                    /*limit to known primes for 1st order. */
                else lim=   #                    /*  "    "  all     "    "  orders ≥ 2.*/
      $=                                         /*$:  a line (output) of Wilson primes.*/
         do j=1  for lim;    p= @.j              /*search through some generated primes.*/
         if (nf*!(p-n)-z)//sq.j\==0 then iterate /*expression ~ q.j ?  No, then skip it.*/       /* ◄■■■■■■■ the filter.*/
         $= $  ' '  commas(p)                    /*add a commatized prime  ──►  $  list.*/
         end   /*p*/

      if $==''  then $= '        (none found within the range specified)'
      say center(n, 7)'│'  substr($, 2)          /*display what Wilson primes we found. */
      end   /*n*/
say '───────┴'center(""   , w, '─')
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
!:      arg x; if !!.x\==.  then return !!.x;  a=1;  do f=1  for x;   a=a*f; end; return a
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
facts:  !!.= 1;   x= 1;  do  f=1  for hip;   x= x * f;   !!.f= x;           end;  return
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP:        @.1=2; @.2=3; @.3=5; @.4=7;  @.5=11 /*define some low primes.              */
      !.=0;  !.2=1; !.3=1; !.5=1; !.7=1;  !.11=1 /*   "     "   "    "     semaphores.  */
      sq.1=4; sq.2=9; sq.3= 25; sq.4= 49; #= 5;  sq.#= @.#**2   /*squares of low primes.*/
        do j=@.#+2  by 2  for max(0, hip%2-@.#%2-1)     /*find odd primes from here on. */
        parse var  j   ''  -1  _;  if    _==5  then iterate    /*J ÷ 5?   (right digit).*/
        if j//3==0  then iterate;  if j//7==0  then iterate    /*" " 3?    Is J ÷ by 7? */
               do k=5  while sq.k<=j             /* [↓]  divide by the known odd primes.*/
               if j // @.k == 0  then iterate j  /*Is  J ÷ X?  Then not prime.     ___  */
               end   /*k*/                       /* [↑]  only process numbers  ≤  √ J   */
        #= #+1;    @.#= j;    sq.#= j*j;  !.j= 1 /*bump # of Ps; assign next P;  P²; P# */
        end          /*j*/;               return
