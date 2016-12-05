/*REXX program finds largest  left─ and right─truncatable  primes ≤ 1m  (or argument 1).*/
parse arg high .;    if high==''  then high=1000000        /*Not specified?  Then use 1m*/
!.=0;   w=length(high)                           /*placeholders for primes;  max width. */
@.1=2;  @.2=3;  @.3=5;  @.4=7;  @.5=11;  @.6=13;  @.7=17   /*define some low primes.    */
!.2=1;  !.3=1;  !.5=1;  !.7=1;  !.11=1;  !.13=1;  !.17=1   /*set some low prime flags.  */
#=7;    s.#=@.#**2                               /*number of primes so far;     prime². */
                                                 /* [↓]  generate more  primes  ≤  high.*/
   do j=@.#+2  by 2  to high                     /*only find odd primes from here on out*/
                        if j// 3==0 then iterate /*is J divisible by three?             */
   parse var j '' -1 _; if     _==5 then iterate /* " "     "      " five? (right digit)*/
                        if j// 7==0 then iterate /* " "     "      " seven?             */
                        if j//11==0 then iterate /* " "     "      " eleven?            */
                        if j//13==0 then iterate /* " "     "      " thirteen?          */
                                                 /* [↑]  the above five lines saves time*/
          do k=7  while s.k<=j                   /* [↓]  divide by the known odd primes.*/
          if j//@.k==0  then iterate j           /*Is J divisible by X?  Then not prime.*/
          end   /*k*/
   #=#+1                                         /*bump the number of primes found.     */
   @.#=j;      s.#=j*j;     !.j=1                /*assign next prime;  prime²;  prime #.*/
   end         /*j*/
                                                 /* [↓]  find largest left truncatable P*/
  do L=#  by -1  for #;    digs=length(@.L)      /*search from top end;  get the length.*/
        do k=1  for digs;  _=right(@.L, k)       /*validate all left truncatable primes.*/
        if \!._  then iterate L                  /*Truncated number not prime?  Skip it.*/
        end   /*k*/
  leave                                          /*egress, found left truncatable prime.*/
  end         /*L*/
                                                 /* [↓]  find largest right truncated P.*/
  do R=#  by -1  for #;    digs=length(@.R)      /*search from top end;  get the length.*/
        do k=1  for digs;  _=left(@.R, k)        /*validate all right truncatable primes*/
        if \!._  then iterate R                  /*Truncated number not prime?  Skip it.*/
        end   /*k*/
  leave                                          /*egress, found right truncatable prime*/
  end         /*R*/
                                                 /* [↓]  show largest left/right trunc P*/
say 'The last prime found is '   @.#    " (there are"   #   'primes ≤'  high")."
say copies('─', 70)                              /*show a separator line for the output.*/
say 'The largest  left─truncatable prime ≤'        high        " is "       right(@.L, w)
say 'The largest right─truncatable prime ≤'        high        " is "       right(@.R, w)
                                                 /*stick a fork in it,  we're all done. */
