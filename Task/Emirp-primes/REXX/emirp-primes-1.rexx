/*REXX program finds  emirp  primes (base 10):  when a prime reversed, is another prime.*/
parse arg x y .                                  /*obtain optional arguments from the CL*/
if x=='' | x==","  then do;  x=1;  y=20;  end    /*Not specified?  Then use the default.*/
if y==''  then y=x                               /* "      "         "   "   "     "    */
r=y<0;    y=abs(y)                               /*display a  range  of  emirp primes ? */
rly=length(y) + \r                               /*adjusted length of the  Y  value.    */
!.=0;  c=0;   _=2 3 5 7 11 13 17;   $=           /*isP; emirp count; low primes; emirps.*/
    do #=1  for words(_);   p=word(_,#);   @.#=p;    !.p=1;    end  /*#*/
#=#-1;   ip=#;  s.#=@.#**2                       /*adjust # (for the DO loop);  last P².*/
                            /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒ [↓]   generate more primes within range.   */
    do j=@.#+2  by 2                             /*only find  odd  primes from here on. */
    if length(#)>rly  then leave                 /*have we enough primes for emirps?    */
    if j//3      ==0  then iterate               /*is  J  divisible by three?           */
    if right(j,1)==5  then iterate               /*is the right-most digit a "5" ?      */
    if j//7      ==0  then iterate               /*is  J  divisible by seven?           */
    if j//11     ==0  then iterate               /*is  J  divisible by eleven?          */
    if j//13     ==0  then iterate               /*is  J  divisible by thirteen?        */
                                                 /*[↑]  the above five lines saves time.*/
          do k=ip  while  s.k<=j                 /*divide by the known  odd  primes.    */
          if j//@.k==0  then iterate j           /*J divisible by X?  Then ¬prime.   ___*/
          end   /*k*/                            /* [↑]  divide by odd primes up to √ j */
    #=#+1                                        /*bump the number of primes found.     */
    @.#=j;      s.#=j*j;     !.j=1               /*assign to sparse array; prime²; prime*/
    end         /*j*/                            /* [↑]  keep generating until enough.  */
                            /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒ [↓]    filter  emirps  for the display.    */
    do j=6  to @.#;   _=@.j                      /*traipse through the regular primes.  */
    if (r&_>y) | (\r&c==y)  then leave           /*is the prime not within the range?   */
    __=reverse(_)                                /*reverse (digits) of the regular prime*/
    if \!.__   | _==__    then iterate           /*is the  reverse  a different prime ? */
    c=c+1                                        /*bump the emirp prime counter.        */
    if (r&_<x) | (\r&c<x) then iterate           /*is  emirp  not within allowed range? */
    $=$ _                                        /*append prime to the emirpPrime list. */
    end   /*j*/                                  /* [↑]  list:  by value  or  by range. */
                                                 /* [↓]  display the emirp list.        */
say strip($);   say;   n=words($);   ?=(n\==1)   /*display the  emirp primes  wanted.   */
if ?  then say  n   'emirp primes shown.'        /*stick a fork in it,  we're all done. */
