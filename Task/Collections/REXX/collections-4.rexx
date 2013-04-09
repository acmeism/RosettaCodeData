primeList='2 3 5 7 11 13 17 19 23 29 31 37 41 43'    /* or ...  */
primeList= 2 3 5 7 11 13 17 19 23 29 31 37 41 43

                    /*in this case, the quotes (') can be dropped. */

primes=words(primeList)

  do j=1  for primes      /*can also be coded:    do j=1 to primes */
  say 'prime' j 'is' word(primeList,j)
  end   /*j*/
