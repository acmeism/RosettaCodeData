/*REXX program  generates  primes  via a  wheeled  sieve of Eratosthenes  algorithm.    */
parse arg H .;   if H=='' | H==","  then H=200   /*obtain the optional argument from CL.*/
w=length(H);     @prime=right('prime', 20)       /*w:  is used for aligning the output. */
if 2<=H  then  say  @prime  right(1, w)     " ───► "    right(2, w)
#= 2<=H                                          /*the number of primes found  (so far).*/
@.=.                                             /*assume all the numbers are  prime    */
!=0                                              /*skips the top part of  sieve marking.*/
    do j=3  by 2  for (H-2)%2                    /*the odd integers up to  H  inclusive.*/
    if @.j==''  then iterate                     /*Is composite?  Then skip this number.*/
    #=#+1                                        /*bump the prime number counter.       */
    say  @prime right(#,w)   " ───► " right(j,w) /*display the prime to the terminal.   */
    if !        then iterate                     /*should the top part be skipped ?     */
    jj=j*j                                       /*compute the square of  j.   ___      */
    if jj>H     then !=1                         /*indicate skipping  if  j > √ H       */
        do m=jj  to H  by j+j; @.m=; end /*m*/   /*strike odd multiples as  not  prime. */
    end   /*j*/                                  /*       ───                           */
say
say right(#, w+length(@prime)+1) 'primes found.' /*stick a fork in it,  we're all done. */
