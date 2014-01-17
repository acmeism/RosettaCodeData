/*REXX program finds the  greatest element  in an array (of numbers).   */
say 'Please enter a list of numbers (separated by blanks or commas):'
parse pull nums                        /*get a list from console (user).*/
nums=translate(nums,,',')              /*change  commas (,)  to  blanks.*/
items=words(nums)                      /*obtain the number of numbers.  */
big=word(nums,1)                       /*assume the biggest is the 1st #*/

        do j=2  to items               /*traipse through the list.      */
        big = max(big, word(nums,j) )  /*use a BIF for finding the max. */
        end   /*j*/

say 'the biggest value in the list of '    items    " elements is: "   big
                                       /*stick a fork in it, we're done.*/
