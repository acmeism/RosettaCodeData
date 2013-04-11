/*REXX program checks if a number (base 10) is  self-describing,        */
/*                                              self-descriptive,       */
/*                                              autobiographical,   or  */
/*                                              a curious number.       */
/*                                                                      */
/*                                  Also see:   http://oeis.org/A046043 */
/*                                       and:   http://oeis.org/A138480 */

parse arg x y .                        /*get args from the command line.*/
if x=='' then exit                     /*if no X, then get out of Dodge.*/
if y=='' then y=x                      /*if no Y, then use the X value. */
y=min(y,999999999)
w=length(y)                            /*use Y's width for pretty output*/
/*══════════════════════════════════════test for a single number.       */
if x==y then do                        /*handle the case of a single #. */
             noYes=test_sdn(y)         /*is it  or  ain't it?           */
             say y word("is isn't",noYes+1) 'a self-describing number.'
             exit
             end
/*══════════════════════════════════════test for a range of numbers.    */
         do n=x to y
         if test_sdn(n) then iterate   /*if ¬ self-describing, try again*/
         say  right(n,w)  'is a self-describing number.'       /*is it? */
         end   /*n*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────TEST_SDN subroutine─────────────────*/
test_sdn:  procedure;     parse arg ?;     L=length(?)
     do j=L  to 1  by -1               /*backwards is slightly faster.  */
     if substr(?,j,1)\==L-length(space(translate(?,,j-1),0)) then return 1
     end   /*j*/
return 0                               /*faster if inverted truth table.*/
/* ┌──────────────────────────────────────────────────────────────────┐
   │ The method used above is to TRANSLATE the digit being queried to │
   │ blanks,  then use the  SPACE  bif function to remove all blanks, │
   │ and then compare the new number's length to the original length. │
   │ The difference in length is the number of digits translated.     │
   │ This method works if there're no imbedded/leading/trailing blanks│
   │ (or other whitespace like tabs)  in the number.                  │
   └──────────────────────────────────────────────────────────────────┘ */
