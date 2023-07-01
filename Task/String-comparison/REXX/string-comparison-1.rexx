/*REXX program shows  different ways to  compare  two character strings.*/
say 'This is an '      word('ASCII EBCDIC', 1+(1=='f1'))        ' system.'
say
      cat = 'cat'
   animal = 'dog'
if animal =  cat  then say $(animal) "is lexically equal to"        $(cat)
if animal \= cat  then say $(animal) "is not lexically equal to"    $(cat)
if animal >  cat  then say $(animal) "is lexically higher than"     $(cat)
if animal <  cat  then say $(animal) "is lexically lower than"      $(cat)
if animal >  cat  then say $(animal) "is not lexically lower than"  $(cat)
if animal <  cat  then say $(animal) "is not lexically higher than" $(cat)

                      /*──── [↑]  The above comparative operators don't */
                      /*────consider any leading and/or trailing white- */
                      /*────space when making comparisons, but the case */
                      /*────is honored  (uppercase, lowercase).         */

fatcat='  cat  '      /*pad the cat with leading and trailing blanks.   */
if fatcat =  cat  then say $(fatcat) " is equal to"                 $(cat)

                      /*────To consider any whitespace in a comparison, */
                      /*────we need to use strict comparative operators.*/

if fatcat == cat  then say $(fatcat) "is strictly equal to"         $(cat)

                      /*────To perform caseless comparisons, the easiest*/
                      /*────method would be to uppercase a copy of both */
                      /*────operands.  Uppercasing is only done for the */
                      /*────Latin (or Roman) alphabet in REXX.    [↓]   */
kat='cAt'
if caselessComp(cat,kat)  then  say $(cat) 'and' $(kat) "are equal caseless"
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────$ subroutine────────────────────────*/
$:  return '──►'arg(1)'◄──'            /*bracket the string with ──►α◄──*/
/*──────────────────────────────────CASELESSCOMP subroutine─────────────*/
caselessComp:  procedure;  arg a,b     /*ARG  uppercases the A & B args.*/
               return a==b             /*if exactly equal, return  1.   */
