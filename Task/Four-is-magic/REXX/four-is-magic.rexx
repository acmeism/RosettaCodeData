/*REXX pgm converts a # to English into the phrase:  a is b, b is c, ... four is magic. */
numeric digits 3003                              /*be able to handle gihugic numbers.   */
parse arg x                                      /*obtain optional numbers from the C.L.*/
if x=''  then x= -164 0 4 6 11 13 75 100 337 9223372036854775807   /*use these defaults?*/
@.= .                                            /*stemmed array used for memoization.  */
       do j=1  for words(x)                      /*process each of the numbers in list. */
       say 4_is( word(x, j) )                    /*display phrase that'll be returned.  */
       say                                       /*display a blank line between outputs.*/
       end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
4_is:  procedure expose @.;     parse arg #,,$                /*obtain the start number.*/
       if #\==4  then do  until L==4                          /*Not 4?   Process number.*/
                      @.#= $spell#(#  'quiet minus negative') /*spell number in English.*/
                      #= @.#;           L= length(#)          /*get the length of spelt#*/
                      if @.L==.  then @.L= $spell#(L 'quiet') /*¬spelt before? Spell it.*/
                      $= $   #   "is"   @.L','                /*add phrase to the answer*/
                      #= L                                    /*use the new number, ··· */
                      end   /*until*/                         /* ··· which will be spelt*/
       $= strip($ 'four is magic.')              /*finish the sentence with the finale. */
       parse var $ first 2 other;  upper first   /*capitalize the first letter of output*/
       return first  ||  other                   /*return the sentence to the invoker.  */
