/*REXX program  computes and displays  the first    N    K─almost primes from  1 ──► K. */
parse arg N K .                                  /*obtain optional arguments from the CL*/
if N=='' | N==','  then N=10                     /*N  not specified?   Then use default.*/
if K=='' | K==','  then K= 5                     /*K   "      "          "   "     "    */
nn=N;  N=abs(N);   w=length(K)                   /*N positive? Then show K─almost primes*/
limit= (2**K) * N / 2                            /*this is the limit for most K-primes. */
if N==1  then limit=limit * 2                    /*  "   "  "    "    "  a    N    of 1.*/
if K==1  then limit=limit * 4                    /*  "   "  "    "    "  a K─prime  " 2.*/
if K==2  then limit=limit * 2                    /*  "   "  "    "    "  "    "     " 4.*/
if K==3  then limit=limit * 3 % 2                /*  "   "  "    "    "  "    "     " 8.*/
call genPrimes  limit + 1                        /*generate primes up to the  LIMIT + 1.*/
say 'The highest prime computed: '        @.#        " (under the limit of " limit').'
say                                              /* [↓]  define where 1st K─prime is odd*/
d.=0;  d.2=  2;  d.3 =  4;  d.4 =  7;  d.5 = 13;  d.6 = 22;  d.7 =  38;   d.8=63
       d.9=102;  d.10=168;  d.11=268;  d.12=426;  d.13=673;  d.14=1064
d!=0
    do m=1  for  K;    d!=max(d!,d.m)            /*generate & assign 1st K─almost prime.*/
    mr=right(m,w);     mm=m-1

    $=;           do #=1  to min(N, d!)          /*assign some doubled K─almost primes. */
                  $=$  d.mm.# * 2
                  end   /*#*/
    #=#-1
    if m==1  then from=2
             else from=1 + word($, words($) )

        do j=from   until  #==N                  /*process an  K─almost prime  N  times.*/
        if factr()\==m  then iterate             /*not the correct  K─almost  prime?    */
        #=#+1;   $=$ j                           /*bump K─almost counter; append it to $*/
        end   /*j*/                              /* [↑]   generate  N  K─almost  primes.*/

    if nn>0  then say mr"─almost ("N') primes:'     $
             else say '    the last'  mr  "K─almost prime: "   word($, words($))
                                               /* [↓]  assign K─almost primes.*/
          do q=1  for #;     d.m.q=word($,q)             ;   end  /*q*/
          do q=1  for #;  if d.m.q\==d.mm.q*2  then leave;   end  /*q*/
                                               /* [↑]  count doubly-duplicates*/
/*──── say copies('─',40)  'for '   m", "   q-1   'numbers were doubly─duplicated.' ────*/
/*──── say                                                                          ────*/
    end       /*m*/                              /* [↑]  display a line for each K─prime*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
factr: if #.j\==.  then return #.j
       z=j;                                do f=0 while z// 2==0; z=z% 2; end   /*÷ by 2*/
                                           do f=f while z// 3==0; z=z% 3; end   /*÷ "  3*/
                                           do f=f while z// 5==0; z=z% 5; end   /*÷ "  5*/
                                           do f=f while z// 7==0; z=z% 7; end   /*÷ "  7*/
                                           do f=f while z//11==0; z=z%11; end   /*÷ " 11*/
                                           do f=f while z//13==0; z=z%13; end   /*÷ " 13*/
                                           do f=f while z//17==0; z=z%17; end   /*÷ " 17*/
                                           do f=f while z//19==0; z=z%19; end   /*÷ " 19*/

         do i=9    while  @.i<=z;       d=@.i    /*divide by some higher primes.        */
           do f=f  while z//d==0;   z=z%d;  end  /*is  Z  divisible by the  prime  D ?  */
         end   /*i*/                             /* [↑]  find all factors in  Z.        */

       if f==0  then f=1;   #.j=f;   return f    /*Is prime (f≡0)?   Then return unity. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
genPrimes: arg x;             @.=;      @.1=2;     @.2=3;    #.=.;     #=2;     s.#=@.#**2
             do j=@.# +2  by 2  to x             /*only find odd primes from here on.   */
                do p=2  while s.p<=j             /*divide by some known low odd primes. */
                if j//@.p==0  then iterate j     /*Is  J  divisible by X?  Then ¬ prime.*/
                end   /*p*/                      /* [↓]  a prime  (J)  has been found.  */
             #=#+1;    @.#=j;   #.j=1;   s.#=j*j /*bump prime count, and also assign ···*/
             end      /*j*/                      /* ··· the # of factors, prime, prime².*/
           return                                /* [↑]  not an optimal prime generator.*/
