/*REXX program  displays  what  "type"  a variable is  (based on the variable's value). */
signal on noValue                                /*trap for undefined REXX variables.   */
y= 1938       ;           call showType y        /*╔═══════════════════════════════════╗*/
y= 77.1       ;           call showType y        /*║ All REXX variables are stored as  ║*/
y=            ;           call showType y        /*║ character strings, even numbers.  ║*/
y= '   '      ;           call showType y        /*║ If a variable string is numeric,  ║*/
y= 'abc'      ;           call showType y        /*║ all comparisons (IF statements)   ║*/
y= 'ABC'      ;           call showType y        /*║ that are made with numbers are    ║*/
y= 'aBc'      ;           call showType y        /*║ compared numerically.  If not     ║*/
y= '1515'x    ;           call showType y        /*║ numeric,  the string is compared  ║*/
y= '10 11'x   ;           call showType y        /*║ char by char after leading and    ║*/
y= '00 0001'b ;           call showType y        /*║ trailing blanks are removed, and  ║*/
y= '1'b       ;           call showType y        /*║ shorter strings are padded with   ║*/
y= ' + 1938 ' ;           call showType y        /*║ blanks to match the longer string.║*/
y= ' - 1.2e4' ;           call showType y        /*╚═══════════════════════════════════╝*/
y= '1'        ;           call showType y        /*                                     */
                          call showType yyy      /*note:  the variable YYY is undefined.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
noValue:   say '      REXX variable '   condition("D")     ' is undefined.';      exit
/*──────────────────────────────────────────────────────────────────────────────────────*/
showType:  procedure; parse arg x 1 xu; upper xu /*get true value & an uppercase version*/
           @= '      value is';              say  @  x
                                             say  @  'of length'       length(x)
           if  x ==''                   then say  @  "null."
           if  x\==''  &  x=''          then say  @  "all blank."
           if  datatype(x, 'N')         then say  @  "numeric (decimal)."
                                        else say  @  "a character string (not numeric)."
           if  datatype(x, 'W')         then say  @  "an integer (a whole number)."
           if  datatype(x, 'N') &,
              \datatype(x, 'W')         then say  @  "not an integer."
           if  datatype(x, 'N') &,
               pos('E', xu)\==0         then say  @  "a number in exponential format."
           if  datatype(x, 'A')         then say  @  "an alphanumeric string."
           if  datatype(x, 'U')         then say  @  "all uppercase (Latin) letters."
           if  datatype(x, 'L')         then say  @  "all lowercase (Latin) letters."
           if \datatype(x, 'L') &,
              \datatype(x, 'U') &,
               datatype(x, 'M')         then say  @  "of mixed case (Latin) letters."
           if  datatype(x, 'B')         then say  @  "binary."
           if  datatype(x, 'X')         then say  @  "hexadecimal."
           if  datatype(x, 'S')         then say  @  "a REXX symbol."
           say copies('▒',  50)                  /*a fence that is used as a separator. */
           return
