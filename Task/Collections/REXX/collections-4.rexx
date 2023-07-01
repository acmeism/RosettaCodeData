primeList = '2 3 5 7 11 13 17 19 23 29 31 37 41 43'        /* or ···  */
primeList =  2 3 5 7 11 13 17 19 23 29 31 37 41 43

                                  /*in this case, the quotes  (')  can be elided.*/

primes= words(primeList)          /*the  WORDS  BIF  counts the number of blank─ */
                                  /*separated words (in this case, prime numbers)*/
                                  /*in the  value  of the variable   "primeList".*/

  do j=1  for primes              /*can also be coded as:      do j=1  to primes */
  say 'prime'    j    "is"    word(primeList, j)
                                  /*this method  (using the   WORD   BIF) isn't  */
                                  /*very efficient for very large arrays  (those */
                                  /*with many many thousands of elements).       */
  end   /*j*/
