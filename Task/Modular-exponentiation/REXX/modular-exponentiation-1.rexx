/*REXX program  displays  modular exponentiation of:             a**b  mod  M           */
parse arg a b mm                                      /*obtain optional args from the CL*/
if a=='' | a==","  then a=2988348162058574136915891421498819466320163312926952423791023078876139
if b=='' | b==","  then b=2351399303373464486466122544523690094744975233415544072992656881240319
if mm='' | mm=","  then mm=40                         /*MM not specified?   Use default.*/
say 'a=' a;   say "        ("length(a) 'digits)'      /*display the  value of  A.       */
say 'b=' b;   say "        ("length(b) 'digits)'      /*   "     "     "    "  B.       */

     do j=1  for words(mm);   m=word(mm,j)            /*use one of the MM powers (list).*/
     say copies('─', linesize()-1)                    /*show a nice separator fence line*/
     say 'a**b (mod 10**'m")="   powerMod(a,b,10**m)  /*display the answer ───► console.*/
     end   /*j*/
exit                                                  /*stick a fork in it, we're done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
powerMod: procedure;  parse arg x,p,n                 /*fast modular exponentiation code*/
          if p==0  then return 1                      /*special case of  P  being zero. */
          if p==1  then return x                      /*   "      "   "  "    "   unity.*/
          if p<0   then do;   say '***error*** power is negative:'  p;    exit 13;     end
          parse value max(x**2,p,n)'E0'  with  "E" e  /*obtain the biggest of the three.*/
          numeric digits max(20, e*2)                 /*big enough to handle  A².       */
          _=1                                         /*use this for the first value.   */
                     do  while p\==0                  /*perform  while   P   isn't zero.*/
                     if p//2  then _=_*x//n           /*is  P  odd?  (is ÷ remainder≡1).*/
                     p=p%2;        x=x*x//n           /*halve  P;   calculate  x² mod n */
                     end   /*while*/                  /* [↑]  keep mod'ing 'til equal 0.*/
          return _
