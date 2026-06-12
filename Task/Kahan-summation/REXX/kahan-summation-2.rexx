/*REXX program demonstrates  simple addition  versus using  Kahan  summation algorithm. */
numeric digits 6                                 /*use six decimal digits for precision.*/
call show  10000.0,  3.14169,  2.71828           /*invoke SHOW to sum & display numbers.*/
numeric digits 30                                /*from now on, use  30  decimal digits.*/
epsilon= 1
                   do  while  1+epsilon \= 1     /*keep looping 'til we can't add unity.*/
                   epsilon= epsilon / 2          /*halve the value of  epsilon variable.*/
                   end   /*while*/
say                                              /*display a blank line before the fence*/
say copies('▒', 70);    say                      /*display a fence, then a blank line.  */
                                                 /* [↓]  for Regina REXX 3.4 and later. */
numeric digits digits()+2                        /*bump the precision by two dec digits.*/
call show   1.0,   epsilon,  -epsilon            /*invoke SHOW to sum & display numbers.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
kahan: procedure;  $= 0;   c= 0;        do j=1  for arg()  /*perform for each argument. */
                                        y= arg(j) - c      /*subtract  C  from argument.*/
                                        t= $ + y           /*use a temporary sum  (T).  */
                                        c= t - $ - y       /*compute the value of  C.   */
                                        $= t               /*redefine the sum  ($).     */
                                        end   /*j*/
       return $
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:  procedure;  parse arg a,b,c                         /*obtain the arguments.      */
       say 'decimal digits ='  digits()                    /*show number of decimal digs*/
       say '   a = '     left("", a>=0)      a             /*display   A   justified.   */
       say '   b = '     left("", b>=0)      b             /*   "      B       "        */
       say '   c = '     left("", c>=0)      c             /*   "      C       "        */
       say 'simple summation of a,b,c = '         a+ b+ c  /*compute simple summation.  */
       say 'Kahan  summation of a,b,c = '   kahan(a, b, c) /*sum via Kahan  summation.  */
       return
