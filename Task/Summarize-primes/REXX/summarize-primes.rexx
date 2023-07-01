/*REXX pgm finds summation primes P,  primes which the sum of primes up to P are prime. */
parse arg hi .                                   /*obtain optional argument from the CL.*/
if hi=='' | hi==","  then hi= 1000               /*Not specified?  Then use the default.*/
call genP                                        /*build array of semaphores for primes.*/
w= 30;     w2= w*2%3;      pad= left('',w-w2)    /*the width of the columns two & three.*/
title= ' summation primes which the sum of primes up to  P  is also prime,  P  < '  ,
                                    commas(hi)
say ' index │' center(subword(title, 1, 2), w)  center('prime sum', w)  /*display title.*/
say '───────┼'center(""   , 1 + (w+1)*2,  '─')                          /*   "    sep.  */
found= 0                                         /*initialize # of summation primes.    */
                                      $= 0       /*sum of primes up to the current prime*/
          do j=1  for hi-1;  p= @.j;  $= $ + p   /*find summation primes within range.  */
          if \!.$  then iterate                  /*Is sum─of─primes a prime?  Then skip.*/
          found= found + 1                       /*bump the number of summation primes. */
          say right(j, 6) '│'strip( right(commas(p), w2)pad || right(commas($), w2), "T")
          end   /*j*/

say '───────┴'center(""   , 1 + (w+1)*2,  '─')   /*display foot separator after output. */
say
say 'Found '       commas(found)      title
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP: !.= 0;  sP= 0                              /*prime semaphores;  sP= sum of primes.*/
      @.1=2;  @.2=3;  @.3=5;  @.4=7;  @.5=11     /*define some low primes.              */
      !.2=1;  !.3=1;  !.5=1;  !.7=1;  !.11=1     /*   "     "   "    "     flags.       */
                        #=5;  sq.#= @.# **2      /*number of primes so far;     prime². */
                                                 /* [↓]  generate more  primes  ≤  high.*/
        do j=@.#+2  by 2  until @.#>=hi & @.#>sP /*find odd primes where  P≥hi and P>sP.*/
        parse var j '' -1 _; if _==5  then iterate            /*J ÷ by 5?  (right digit)*/
        if j//3==0  then iterate;  if j//7==0  then iterate   /*J ÷ by 3?;   J ÷ by 7?  */
               do k=5  while sq.k<=j             /* [↓]  divide by the known odd primes.*/
               if j // @.k == 0  then iterate j  /*Is  J ÷ X?  Then not prime.     ___  */
               end   /*k*/                       /* [↑]  only process numbers  ≤  √ J   */
        #= #+1;    @.#= j;   sq.#= j*j;   !.j= 1 /*bump # Ps; assign next P; P square; P*/
        if @.#<hi  then sP= sP + @.#             /*maybe add this prime to sum─of─primes*/
        end          /*j*/;               return
