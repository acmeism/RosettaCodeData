/*REXX program calculates and displays primes using an extendible prime number generator*/
parse arg f .;    if f==''  then f=20            /*allow specifying number for  1 ──► F.*/
call primes f;              do j=1  for f;   $=$ @.j;  end /*j*/
say 'first'   f   'primes are:'    $
say
call primes -150;           do j=100  to 150;   if !.j==0  then iterate;  $=$ j; end /*j*/
say 'the primes between 100 to 150 (inclusive) are:'   $
say
call primes -8000;          do j=7700  to 8000; if !.j==0  then iterate;  $=$ j; end /*j*/
say 'the number of primes between 7700 and 8000 (inclusive) is:'  words($)
say
call primes 10000
say 'the 10000th prime is:'  @.10000
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
primes: procedure expose !. s. @. $ #;   parse arg H . 1 m .,,$;   H=abs(H)
        if symbol('!.0')=='LIT'  then            /*1st time here?  Then initialize stuff*/
                      do;  !.=0;  @.=0;  s.=0    /*!.x = some prime;   @.n = Nth prime. */
                      _=2 3 5 7 11 13 17 19 23   /*generate a bunch of low primes.      */
                         do #=1  for words(_);     p=word(_,#);    @.#=p;    !.p=1;    end
                      #=#-1;  !.0=#;  s.#=@.#**2 /*set  #  to be the number of primes.  */
                      end                        /* [↑]  done with building low primes? */
        neg= m<0                                 /*Negative?  Request is for a  P value.*/
        if neg  then  if  H<=@.#  then return    /*do we have a high enough  P  already?*/
                                  else nop       /*this is used to match the above THEN.*/
                else  if  H<=#    then return    /*do we have a enough primes already ? */
                                                 /* [↓]  gen more primes within range.  */
            do j=@.#+2  by 2                     /*find primes until have   H   Primes. */
            if j//3 ==0  then iterate            /*is  J  divisible by three?           */
            parse var j '' -1 _;  if _==5 then iterate    /*is the right-most digit a 5?*/
            if j//7 ==0  then iterate            /*is  J  divisible by seven?           */
            if j//11==0  then iterate            /*is  J  divisible by eleven?          */
            if j//13==0  then iterate            /*is  J  divisible by thirteen?        */
            if j//17==0  then iterate            /*is  J  divisible by seventeen?       */
            if j//19==0  then iterate            /*is  J  divisible by nineteen?        */
                                                 /*[↑]  above five lines saves time.    */
                  do k=!.0  while  s.k<=j        /*divide by the known  odd  primes.    */
                  if j//@.k==0  then iterate j   /*Is  J  ÷ by a prime?  ¬prime.     ___*/
                  end   /*k*/                    /* [↑]  divide by odd primes up to √ j */
            #=#+1                                /*bump the number of primes found.     */
            @.#=j;      s.#=j*j;    !.j=1        /*assign to sparse array;  prime²;  P#.*/
            if neg  then if H<=@.#  then leave   /*do we have a high enough prime?      */
                                    else nop     /*used to match the above  THEN.       */
                    else if H<=#    then leave   /*do we have enough primes yet?        */
            end         /*j*/                    /* [↑]  keep generating until enough.  */
        return                                   /*return to invoker with more primes.  */
