/*REXX program finds largest  left─ and right─truncatable  primes ≤ 1m  (or argument 1).*/
parse arg HI .;      if HI==''  then HI= 1000000 /*Not specified? Then use default of 1m*/
!.= 0;               w= length(HI)               /*placeholders for primes;  max width. */
@.1=2;   @.2=3;   @.3=5;   @.4=7;   @.5=11       /*define  some  low  primes.           */
!.2=1;   !.3=1;   !.5=1;   !.7=1;   !.11=1       /*   "      "    "     "     flags.    */
                  #=5;         s.#= @.# **2      /*number of primes so far;     prime². */
                                                 /* [↓]  generate more  primes  ≤  high.*/
  do j=@.#+2  by 2  for max(0, HI%2 - @.#%2 - 1) /*only find odd primes from here on out*/
                       if j// 3==0  then iterate /*is J divisible by three?             */
  parse var j '' -1 _; if     _==5  then iterate /* " "     "      " five? (right digit)*/
                       if j// 7==0  then iterate /* " "     "      " seven?             */
                                                 /* [↑]  the above five lines saves time*/
        do k=5  while s.k<=j                     /* [↓]  divide by the known odd primes.*/
        if j // @.k == 0  then iterate j         /*Is  J ÷ X?  Then not prime.     ___  */
        end   /*k*/                              /* [↑]  only process numers  ≤   √ J   */
  #= #+1                                         /*bump the number of primes found.     */
  @.#= j;            s.#= j * j;        !.j= 1   /*assign next prime;  prime²;  prime #.*/
  end         /*j*/
                                                 /* [↓]  find largest left truncatable P*/
  do L=#  by -1  for #                           /*search from top end;  get the length.*/
       do k=1  for length(@.L);  _=right(@.L, k) /*validate all left truncatable primes.*/
       if \!._  then iterate L                   /*Truncated number not prime?  Skip it.*/
       end   /*k*/
  leave                                          /*egress, found left truncatable prime.*/
  end         /*L*/
                                                 /* [↓]  find largest right truncated P.*/
  do R=#  by -1  for #                           /*search from top end;  get the length.*/
       do k=1  for length(@.R);  _= left(@.R, k) /*validate all right truncatable primes*/
       if \!._  then iterate R                   /*Truncated number not prime?  Skip it.*/
       end   /*k*/
  leave                                          /*egress, found right truncatable prime*/
  end        /*R*/
                                                 /*stick a fork in it,  we're all done. */
say 'The largest  left─truncatable prime ≤'        HI        " is "       right(@.L, w)
say 'The largest right─truncatable prime ≤'        HI        " is "       right(@.R, w)
