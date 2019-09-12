/*REXX pgm prompts (using the OS GUI) for a string & then prompts for a specific number.*/
#= 75000                                         /*the number that   must be   entered. */
x=
N=
     do while x=' ';       say                   /*string can't be blanks or null string*/
     say 'Please enter a string: '
     parse pull x
     if x=''  then say '***error***  No string entered.'
     end   /*while x···*/

     do while N\=#;        say                   /*the number (below) may be ill formed.*/
     say 'Please enter the number:'   #
     parse pull N
     if datatype(N, 'N')  then N= N / 1          /*normalize the number:  007  4.0  +2  */
     if N\=#  then say '***error***  The number is not correct: '   N.
     end   /*while N···*/
say
say 'The string entered is:'  x                  /*echo the values  (string and number. */
say 'The number entered is:'  N                  /*stick a fork in it,  we're all done. */
