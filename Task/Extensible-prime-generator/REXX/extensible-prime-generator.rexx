/*REXX program finds primes using an  extendible prime number generator.*/
parse arg f .;    if f==''  then f=20  /*allow specifying # for 1 ──► F.*/
call primes f;    do j=1  for f;   $=$ @.j;  end
say 'first' f 'primes are:'  $
say
call primes -150;   do j=100  to 150;  if !.j==0  then iterate; $=$ j; end
say 'the primes between 100 to 150 (inclusive) are:'  $
say
call primes -8000;  do j=7700 to 8000; if !.j==0  then iterate; $=$ j; end
say 'the number of primes between 7700 and 8000 (inclusive) is:'  words($)
say
call primes 10000
say 'the 10000th prime is:'  @.10000
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────PRIMES subroutine───────────────────*/
primes: procedure expose !. s. @. $ #;   parse arg H . 1 m .,,$;  H=abs(H)
if symbol('!.0')=='LIT'  then          /*1st time here? Initialize stuff*/
              do;  !.=0;  @.=0;  s.=0  /*!.x=some prime;  @.n=Nth prime.*/
              _=2 3 5 7 11 13 17 19 23 /*generate a bunch of low primes.*/
                 do #=1  for words(_);   p=word(_,#);  @.#=p;  !.p=1;  end
              #=#-1; !.0=#; s.#=@.#**2 /*set  #  to be number of primes.*/
              end                      /* [↑]  done with building low Ps*/
neg= m<0                               /*Neg?  Request is for a P value.*/
if neg  then  if  H<=@.#  then return  /*Have a high enough  P  already?*/
                          else nop     /*used to match the above  THEN. */
        else  if  H<=#    then return  /*Have a enough primes already ? */
/*─────────────────────────────────────── [↓]  gen more P's within range*/
    do j=@.#+2  by 2                   /*find primes until have H Primes*/
    if j//3      ==0  then iterate     /*is  J  divisible by three?     */
    if right(j,1)==5  then iterate     /*is the right-most digit a "5" ?*/
    if j//7      ==0  then iterate     /*is  J  divisible by seven?     */
    if j//11     ==0  then iterate     /*is  J  divisible by eleven?    */
    if j//13     ==0  then iterate     /*is  J  divisible by thirteen?  */
    if j//17     ==0  then iterate     /*is  J  divisible by seventeen? */
    if j//19     ==0  then iterate     /*is  J  divisible by nineteen?  */
                                      /*[↑] above seven lines saves time*/
          do k=!.0  while  s.k<=j      /*divide by the known odd primes.*/
          if j//@.k==0  then iterate j /*Is J divisible by P? Not prime.*/
          end   /*k*/                  /* [↑]  divide by odd primes  √j.*/
    #=#+1                              /*bump number of primes found.   */
    @.#=j;      s.#=j*j;    !.j=1      /*assign to sparse array; prime².*/
    if neg  then if H<=@.#  then leave /*do we have a high enough prime?*/
                            else nop   /*used to match the above  THEN. */
            else if H<=#    then leave /*do we have enough primes yet?  */
    end         /*j*/                  /* [↑]  keep generating 'til nuff*/
return                                 /*return to invoker with more Ps.*/
