                /*╔════════════════════════════════════════════════════════════════════╗
                  ║ Calling a function with optional arguments.                        ║
                  ║                                                                    ║
                  ║ Note that not passing an argument isn't the same as passing a null ║
                  ║ argument  (a REXX variable whose value is length zero).            ║
                  ╚════════════════════════════════════════════════════════════════════╝*/

x= 12;   w= x/2;   y= x**2;    z= x//7           /* z  is  x  modulo seven.             */
say 'sum of w, x, y, & z='  SumIt(w,x,y,,z)      /*pass five args, the 4th arg is "null"*/
exit                                             /*stick a fork in it,  we're all done. */

SumIt: procedure
       $= 0                                      /*initialize the sum to zero.          */
             do j=1  for arg()                   /*obtain the sum of a number of args.  */
             if arg(j,'E')  then $= $ + arg(j)   /*the  Jth  arg may have been omitted. */
             end   /*j*/

       return $
