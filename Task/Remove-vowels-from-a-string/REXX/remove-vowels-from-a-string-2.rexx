/*REXX program removes vowels (both lowercase and uppercase and accented) from a string.*/
parse arg x                                      /*obtain optional argument from the CL.*/
if x='' | x=","  then x= 'REXX Programming Language'  /*Not specified?  Then use default*/
say ' input string: '    x
vowels= 'AEIOUaeiou' || "üéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜáíóúªºαΩ"  /*Latin + accented + Greek*/
x= . || x                                        /*prefix string with a dummy character.*/

     do j=length(x)-1  by -1  for  length(x)-1   /*process the string from the back─end.*/
     _= pos( substr(x, j, 1), vowels)            /*is this particular character a vowel?*/
     if _==0  then iterate                       /*if zero  (not a vowel), then skip it.*/
     x= left(x, j - 1)  ||  substr(x, j + 1)     /*elide the vowel just detected from X.*/
     end   /*j*/

x= substr(x, 2)                                  /*elide the prefixed dummy character.  */
say 'output string: '    x                       /*stick a fork in it,  we're all done. */
