/*REXX program finds primes in which sum of primes  ≤  P  is prime,  where  P  <  1.000.*/
parse arg hi cols .                              /*obtain optional argument from the CL.*/
if   hi=='' |   hi==","  then   hi= 1000         /*Not specified?  Then use the default.*/
if cols=='' | cols==","  then cols=   10         /* "      "         "   "   "     "    */
call genP                                        /*build array of semaphores for primes.*/
w= 10                                            /*the width of a number in any column. */
title= ' primes which the sum of primes  ≤  P  is prime,  where  P  < '     commas(hi)
say ' index │' center(title, 1 + cols*(w+1)     )
say '───────┼'center(""    , 1 + cols*(w+1), '─')
found= 0;                           idx = 1      /*number of primes found (so far); IDX.*/
$=;                                 pSum= 0      /*#: list of primes (so far); init pSum*/
        do j=1  for hi-1;  p= @.j;  pSum= pSum+p /*find summation primes within range.  */
        if \!.pSum  then iterate                 /*Is sum─of─primes a prime?  Then skip.*/
        found= found + 1                         /*bump the number of found  primes.    */
        if cols<0             then iterate       /*Build the list  (to be shown later)? */
        c= commas(p)                             /*maybe add commas to the number.      */
        $= $ right(c, max(w, length(c) ) )       /*add a found prime──►list, allow big #*/
        if found//cols\==0    then iterate       /*have we populated a line of output?  */
        say center(idx, 7)'│'  substr($, 2);  $= /*display what we have so far  (cols). */
        idx= idx + cols                          /*bump the  index  count for the output*/
        end   /*j*/

if $\==''  then say center(idx, 7)"│"  substr($, 2)  /*possible display residual output.*/
say '───────┴'center(""    , 1 + cols*(w+1), '─')
say
say 'Found '       commas(found)      title
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP: !.= 0;  sP= 0                              /*prime semaphores;  sP= sum of primes.*/
      @.1=2;  @.2=3;  @.3=5;  @.4=7;  @.5=11     /*define some low primes.              */
      !.2=1;  !.3=1;  !.5=1;  !.7=1;  !.11=1     /*   "     "   "    "     flags.       */
                        #=5;     sq.#= @.# **2   /*number of primes so far;     prime². */
                                                 /* [↓]  generate more  primes  ≤  high.*/
        do j=@.#+2  by 2  until @.#>=hi & @.#>sP /*find odd primes where  P≥hi and P>sP.*/
        parse var j '' -1 _; if     _==5  then iterate  /*J divisible by 5?  (right dig)*/
                             if j// 3==0  then iterate  /*"     "      " 3?             */
                             if j// 7==0  then iterate  /*"     "      " 7?             */
               do k=5  while sq.k<=j             /* [↓]  divide by the known odd primes.*/
               if j // @.k == 0  then iterate j  /*Is  J ÷ X?  Then not prime.     ___  */
               end   /*k*/                       /* [↑]  only process numbers  ≤  √ J   */
        #= #+1;    @.#= j;    sq.#= j*j;  !.j= 1 /*bump # of Ps; assign next P;  P²; P# */
        if @.#<hi  then sP= sP + @.#             /*maybe add this prime to sum─of─primes*/
        end          /*j*/;               return
