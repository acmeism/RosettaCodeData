/*REXX pgm finds the  prime factors  of a (or some) positive integer(s).*/
numeric digits 1000                    /*handle 1,000 digits for powers.*/
parse arg    bot top  step   base  add /*get optional arguments from CL.*/
if  bot==''  then do;bot=1;top=100;end /*no  BOT?  Then use the default.*/
if  top==''  then          top=bot     /* "  TOP?    "   "   "     "    */
if step==''  then step=1               /* " STEP?    "   "   "     "    */
if add ==''  then add=-1               /* "  ADD?    "   "   "     "    */
w=length(top)                          /*get max width (pretty display).*/
if base\=='' then w=length(base**top)  /*will we be testing powers?.    */
@.=left('',7);    @.0='{unity}';  @.1='[prime]'     /*literals: (¬)prime*/
numeric digits max(9,w+1)              /*maybe increase the precision.  */
p=0                                    /*P is the number of primes found*/
        do n=bot  to top  by step      /*process single number or range.*/
        ?=n;  if base\==''  then ?=base**n+add   /*do a "Mercenne" test?*/
        f=factr(?);      #=words(f)    /*get prime factors; # of factors*/
        if #==1  then p=p+1            /*N is prime?  Bump prime counter*/
        say right(?,w)   right('('#")",9)   'prime factors: '  @.#   f
        end   /*n*/
say                                    /* [↓] if multiple numbers, show.*/
if top-bot+1\==1  then say right(p,w+9+1)  'primes found.'   /*show cnt.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FACTR subroutine────────────────────*/
factr: procedure; parse arg x 1 z,list /*sets X&Z to arg1, LIST to null.*/
if x==1  then return ''                /*handle the special case of X=1.*/
j=2;     call .factr                   /*factor for the only even prime.*/
j=3;     call .factr                   /*factor for the 1st  odd  prime.*/
j=5;     call .factr                   /*factor for the 2nd  odd  prime.*/
j=7;     call .factr                   /*factor for the 3rd  odd  prime.*/
j=11;    call .factr                   /*factor for the 4th  odd  prime.*/
j=13;    call .factr                   /*factor for the 5th  odd  prime.*/
j=17;    call .factr                   /*factor for the 6th  odd  prime.*/
                                       /* [↑]   could be optimized more.*/
                                       /* [↓]   J in loop starts at 17+2*/
     do y=0  by 2;     j=j+2+y//4      /*insure J isn't divisible by 3. */
     if right(j,1)==5  then iterate    /*fast check for divisible by 5. */
     if j*j>z          then leave      /*are we higher than the √ of Z ?*/
     if j>Z            then leave      /*are we higher than value of Z ?*/
     call .factr                       /*invoke .FACTR for some factors.*/
     end   /*y*/                       /* [↑]  only tests up to the √ X.*/
                                       /* [↓]  LIST has a leading blank.*/
if z==1  then return list              /*if residual=unity, don't append*/
              return list z            /*return list,  append residual. */
/*──────────────────────────────────.FACTR internal subroutine──────────*/
.factr:  do  while z//j==0             /*keep dividing until we can't.  */
         list=list j                   /*add number to the list  (J).   */
         z=z%j                         /*% (percent)  is integer divide.*/
         end   /*while z··· */         /*  //   ◄───remainder integer ÷.*/
return                                 /*finished, now return to invoker*/
