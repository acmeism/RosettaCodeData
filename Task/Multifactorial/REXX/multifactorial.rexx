/*REXX pgm calculates  K-fact (multifactorial) of non-negative integers.*/
numeric digits 1000                    /*lets get ka-razy with precision*/
parse arg num deg .                    /*allow user to specify num & deg*/
if num=='' | num==','  then num=12     /*Not specified? Then use default*/
if deg=='' | deg==','  then deg=10     /* "      "        "   "     "   */

       do d=1  to deg                  /*the degree of factorialization.*/
       _=                              /*the list of factorials so far. */
              do f=1  to  num
              _=_  Kfact(f,d)          /*construct a list of factorials.*/
              end   /*f*/              /*(above)   D  can be omitted.   */

       say  'degree'   right(d,length(num))':'   _    /*show factorials.*/
       end   /*d*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────KFACT subroutine────────────────────*/
Kfact: procedure;  !=1;      do j=arg(1)  to 2  by -word(arg(2) 1, 1)
                             !=!*j
                             end   /*j*/
return !
