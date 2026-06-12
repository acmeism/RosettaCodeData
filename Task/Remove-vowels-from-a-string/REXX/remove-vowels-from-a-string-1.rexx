/*REXX program removes vowels (both lowercase and uppercase and accented) from a string.*/
parse arg x                                      /*obtain optional argument from the CL.*/
if x='' | x=","  then x= 'REXX Programming Language'  /*Not specified?  Then use default*/
say ' input string: '    x
vowels= 'AEIOUaeiou' || "üéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜáíóúªºαΩ"  /*Latin + accented + Greek*/
$= translate( xrange(), ., ' ')                  /*define a string of almost all chars. */
q= substr($, verify($, x), 1)                    /*find a character NOT in the X string.*/
y= translate(x, q, " ")                          /*trans. blanks in the string (for now)*/
y= space(translate(y, , vowels), 0)              /*trans. vowels──►blanks, elide blanks.*/
y= translate(y, , q)                             /*trans the Q characters back to blanks*/
say 'output string: '    y                       /*stick a fork in it,  we're all done. */
