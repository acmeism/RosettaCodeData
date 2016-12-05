/*REXX program  displays  divisors  of any [negative/zero/positive]  integer or a range.*/
parse arg LO HI inc .                                         /*obtain the optional args*/
HI=word(HI LO 20, 1);  LO=word(LO 1, 1);  inc=word(inc 1, 1)  /*define the range options*/
w=length(high)+2;      numeric digits max(9, w-2);    $='∞'   /*decimal digits for  //  */
@.=left('',7);  @.1="{unity}"; @.2='[prime]'; @.$="  {"$'}  ' /*define some literals.   */
say center('n', w)    "#divisors"    center('divisors', 60)   /*display the  header.    */
say copies('═', w)    "═════════"    copies('═'       , 60)   /*   "     "   separator. */
p#=0                                                          /*count of prime numbers. */
     do n=LO  to HI  by inc; divs=divisors(n); #=words(divs)  /*get list of divs; # divs*/
     if divs==$  then do;  #=$ ; divs= '  (infinite)';  end   /*handle case for infinity*/
     p=@.#;      if n<0  then if n\==-1  then p=@..           /*   "     "   "  negative*/
     if p==@.2  then p#=p#+1                                  /*Prime? Then bump counter*/
     say center(n, w)      center('['#"]", 9)       "──► "        p      ' '       divs
     end   /*n*/                                 /* [↑]   process a range of integers.  */
say
say left('', 17)     p#    ' primes were found.' /*display the number of primes found.  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
divisors: procedure; parse arg x 1 b;     a=1    /*set  X  and  B  to the 1st argument. */
if x<2  then do; x=abs(x);  if x==1  then return 1;  if x==0  then return '∞';  b=x;  end
odd=x//2                                         /* [↓]  process EVEN or ODD ints.   ___*/
        do j=2+odd  by 1+odd  while j*j<x        /*divide by all the integers up to √ x */
        if x//j==0  then do; a=a j; b=x%j b; end /*÷?  Add factors to  α  and  ß  lists.*/
        end   /*j*/                              /* [↑]  %  ≡  integer division.     ___*/
if j*j==x  then  return  a j b                   /*Was  X  a square?   Then insert  √ x */
                 return  a   b                   /*return the divisors of both lists.   */
