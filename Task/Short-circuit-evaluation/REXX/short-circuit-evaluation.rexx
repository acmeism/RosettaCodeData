/*REXX programs demonstrates  short-circuit  evaulation testing.        */

           do i=-2  to 2
           x=a(i)  &  b(i)
           y=a(i)
           if \y  then y=b(i)
           say  copies('─',30)   'x='||x   'y='y   'i='i
           end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────subroutines─────────────────────────*/
a: say 'A entered with:' arg(1);return abs(arg(1)//2)  /*1=odd, 0=even  */
b: say 'B entered with:' arg(1);return arg(1)<0        /*1=neg, 0=if not*/
