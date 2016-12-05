/*REXX program  computes  the  factorial  of an  integer,  striping trailing zeroes.    */
numeric digits 200                               /*start with two hundred digits.       */
parse arg N .;     if N==''  then N=0            /*obtain the optional argument from CL.*/

!=1                                              /*define the factorial product so far. */
    do j=2  to N                                 /*compute factorial the hard way.      */
    old!=!                                       /*save old product in case of overflow.*/
    !=!*j                                        /*multiple the old factorial with   J. */
    if pos(.,!) \==0  then do                    /*is the   !   in exponential notation?*/
                           d=digits()            /*D   temporarily stores number digits.*/
                           numeric digits d+d%10 /*add  10%  to the   decimal digits.   */
                           !=old! * j            /*re─calculate for the  "lost"  digits.*/
                           end                   /*IFF ≡ if and only if.  [↓]           */
    parse var !  '' -1 _                         /*obtain the right-most digit of  !    */
    if _==0  then !=strip(!,,0)                  /*strip trailing zeroes  IFF  the ...  */
    end   /*j*/                                  /* [↑]  ...  right-most digit is zero. */
z=0                                              /*the number of trailing zeroes in  !  */
    do v=5  by 0  while v<=N                     /*calculate number of trailing zeroes. */
    z=z + N%v                                    /*bump   Z   if multiple power of five.*/
    v=v*5                                        /*calculate the next power of five.    */
    end   /*v*/                                  /* [↑]  we only advance  V  by ourself.*/

!=! || copies(0, z)                              /*add water to rehydrate the product.  */
if z==0  then z='no'                             /*use gooder English for the message.  */
say N'!  is      ['length(!)        " digits  with "        z        ' trailing zeroes]:'
say                                              /*display blank line  (for whitespace).*/
say !                                            /*display the factorial product.       */
                                                 /*stick a fork in it,  we're all done. */
