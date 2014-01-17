/*REXX pgm calculates  K-fact (multifactorial) of non-negative integers.*/
numeric digits 1000                    /*lets get ka-razy with precision*/
parse arg num deg .                    /*allow user to specify num & deg*/
if num=='' | num==','   then num=15    /*Not specified? Then use default*/
if deg=='' | deg==','   then deg=10    /* "      "        "   "     "   */
say '═══showing multiple factorials (1 ──►' deg")  for numbers  1 ──►" num
say
     do d=1  for deg                   /*the factorializing (º) of !'s. */
     _=                                /*the list of factorials so far. */
            do f=1  for num            /* ◄── do a  !  from  1  to  num.*/
            _=_  Kfact(f,d)            /*construct a list of factorials.*/
            end   /*f*/                /*(above)   D  can default to  1.*/

     say right('n'copies("!", d),1+deg)  right('['d"]",2+length(num))':' _
     end          /*d*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────KFACT subroutine────────────────────*/
Kfact: procedure;  !=1;      do j=arg(1)  to 2    by  -word(arg(2) 1, 1)
                             !=!*j
                             end   /*j*/
return !
