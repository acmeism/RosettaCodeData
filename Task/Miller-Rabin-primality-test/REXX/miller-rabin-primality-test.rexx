/*REXX program puts Miller-Rabin primality test through its paces.      */

arg limit accur .                      /*get some arguments (if any).   */
if limit=='' | limit==',' then limit=1000   /*maybe assume LIMIT default*/
if accur=='' | accur==',' then accur=10     /*  "      "   ACCUR    "   */
numeric digits max(200,2*limit)        /*we're dealing with some biggies*/
tell=accur<0                           /*show primes if  K  is negative.*/
accur=abs(accur)                       /*now, make  K  positive.        */
call suspenders                        /*suspenders now, belt later...  */
primePi=#                              /*save the count of (real) primes*/
say "There are" primePi 'primes ≤' limit /*might as well crow a wee bit.*/
say                                    /*nothing wrong with whitespace. */
      do a=2 to accur                  /*(skipping 1)  do range of  K's.*/
      say copies('─',79)               /*show separator for the eyeballs*/
      mrp=0                            /*prime counter for this pass.   */

        do z=1 for limit               /*now, let's get busy and crank. */
        p=Miller_Rabin(z,a)            /*invoke and pray...             */
        if p==0 then iterate           /*Not prime?   Then try another. */
        mrp=mrp+1                      /*well, found another one, by gum*/

        if tell then say z,            /*maybe should do a show & tell ?*/
              'is prime according to Miller-Rabin primality test with K='a

        if !.z\==0 then iterate
        say '[K='a"] " z "isn't prime !" /*oopsy-doopsy & whoopsy-daisy!*/
        end   /*z*/

      say 'for 1──►'limit", K="a', Miller-Rabin primality test found' mrp,
          'primes {out of' primePi"}"
      end     /*a*/
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────Miller─Rabin primality test.─────*/
/*─────────────────────────────────────Rabin─Miller (also known as)─────*/
Miller_Rabin:  procedure;   parse arg n,k
if n==2 then return 1                  /*special case of an even prime. */
if n<2 | n//2==0 then return 0         /*check for low,  or even number.*/
d=n-1
nL=n-1                                 /*saves a bit of time, down below*/
s=0

   do while d//2==0;   d=d%2;   s=s+1;   end    /*while d//2==0 */

          do k
          a=random(2,nL)
          x=(a**d) // n                /*this number can get big fast.  */
          if x==1 | x==nL then iterate

              do r=1  for s-1
              x=(x*x) // n
              if x==1  then return 0   /*it's definitely not prime.     */
              if x==nL then leave
              end   /*r*/

          if x\==nL then return 0      /*nope, it ain't prime nohows.   */
          end       /*k*/
                                       /*maybe it is, maybe it ain't ...*/
return 1                               /*coulda/woulda/shoulda be prime.*/
/*──────────────────────────────────SUSPENDERS subroutine───────────────*/
suspenders:     @.=0;    !.=0          /*crank up the ole prime factory.*/
@.1=2;  @.2=3;  @.3=5;   #=3           /*prime the pump with low primes.*/
!.2=1;  !.3=1;  !.5=1                  /*and don't forget the water jar.*/

       do j  =@.#+2 by 2 to limit      /*just process the odd integers. */
           do k=2 while @.k**2<=j      /*let's do the ole primality test*/
           if j//@.k==0 then iterate j /*the Greek way, in days of yore.*/
           end   /*k*/                 /*a useless comment, but hey!!   */
       #=#+1                           /*bump the prime counter.        */
       @.#=j                           /*keep priming the prime pump.   */
       !.j=1                           /*and keep filling the water jar.*/
       end     /*j*/                   /*this comment not left blank.   */
return                                 /*whew!  All done with the primes*/
