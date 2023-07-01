/*REXX program finds largest  left─ and right─truncatable  primes ≤ 1m  (or argument 1).*/
parse arg hi .;      if hi==''  then hi= 1000000 /*Not specified? Then use default of 1m*/
call genP                                        /*generate some primes,  about  hi ÷ 2 */
                                                 /* [↓]  find largest left truncatable P*/
  do L=#  by -1  for #                           /*search from top end;  get the length.*/
       do k=1  for length(@.L); _= right(@.L, k) /*validate all left truncatable primes.*/
       if \!._  then iterate L                   /*Truncated number not prime?  Skip it.*/
       end   /*k*/
  leave                                          /*egress, found left truncatable prime.*/
  end        /*L*/
                                                 /* [↓]  find largest right truncated P.*/
  do R=#  by -1  for #                           /*search from top end;  get the length.*/
       do k=1  for length(@.R);  _= left(@.R, k) /*validate all right truncatable primes*/
       if \!._  then iterate R                   /*Truncated number not prime?  Skip it.*/
       end   /*k*/
  leave                                          /*egress, found right truncatable prime*/
  end        /*R*/

say 'The largest  left─truncatable prime ≤'        hi        " is "       right(@.L, w)
say 'The largest right─truncatable prime ≤'        hi        " is "       right(@.R, w)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP: !.= 0;                     w= length(hi)   /*placeholders for primes;  max width. */
      @.1=2;  @.2=3;  @.3=5;  @.4=7;  @.5=11     /*define some low primes.              */
      !.2=1;  !.3=1;  !.5=1;  !.7=1;  !.11=1     /*   "     "   "    "     flags.       */
                        #=5;     s.#= @.# **2    /*number of primes so far;     prime². */
                                                 /* [↓]  generate more  primes  ≤  high.*/
        do j=@.#+2  by 2  for max(0, hi%2-@.#%2-1)      /*find odd primes from here on. */
        parse var j '' -1 _; if     _==5  then iterate  /*J divisible by 5?  (right dig)*/
                             if j// 3==0  then iterate  /*"     "      " 3?             */
                             if j// 7==0  then iterate  /*"     "      " 7?             */
                                                 /* [↑]  the above five lines saves time*/
               do k=5  while s.k<=j              /* [↓]  divide by the known odd primes.*/
               if j // @.k == 0  then iterate j  /*Is  J ÷ X?  Then not prime.     ___  */
               end   /*k*/                       /* [↑]  only process numbers  ≤  √ J   */
        #= #+1;    @.#= j;    s.#= j*j;   !.j= 1 /*bump # of Ps; assign next P;  P²; P# */
        end          /*j*/
     return
