/*REXX pgm shows smallest & largest positive numbers that can be expressed, compares 0's*/
parse version v;    say 'version=' v;    say
   zero=  '0.0'                                          /*a (positive) value for zero. */
negZero= '-0.0'                                          /*"  negative     "   "    "   */
say 'value of zero         equals negZero: '     word('no yes',   1 + (zero  = negZero) )
say 'value of zero exactly equals negZero: '     word('no yes',   1 + (zero == negZero) )
say
     do digs=20  by 20  to 100;   numeric digits digs          /*use a range of digits. */
     say center(' number of decimal digits being used:'  digs" ", 79, '═')
     say 'tiny=' tiny()
     say 'huge=' huge()
     end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
tiny:  return $xnum('1e-')
huge:  return $xnum('.'copies(9, digits() )"e+")
/*──────────────────────────────────────────────────────────────────────────────────────*/
$xnum: procedure;  parse arg $                           /*use the given mantissa value.*/
       !=10                                              /*use starting  exponent value.*/
                        do forever;  _=$ || !            /*construct a REXX decimal num.*/
                        if \datatype(_, 'N')  then leave /*Not numeric?   Then leave.   */
                        p=!;         !=! * 10            /*save number; magnify mantissa*/
                        end   /*forever*/
       j=! % 2                                           /*halve the exponent (power).  */
                        do forever;  _=$ || !            /* [+]  Not numeric?  Halve it.*/
                        if \datatype(_, 'N')  then do; !=p;     j=j % 2
                                                       if j==0  then leave
                                                   end
                        p=!;         !=! + j             /*save number;  bump mantissa. */
                        end   /*forever*/
       return $ || !
