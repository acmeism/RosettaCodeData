/*REXX program calculates and demonstrates  arbitrary precision numbers.      */
numeric digits 200000                  /*two hundred thousand decimal digits. */

    n = 5 ** (4 ** (3 ** 2))           /*calculate multiple exponentiations.  */

check = 62060698786608744707...92256259918212890625
sampl = left(n, 20)   ||    ...    ||   right(n, 20)

say  ' check:'   check
say  'sample:'   sampl
say  'digits:'   length(n)
say
if check==sampl  then say 'passed!'
                 else say 'failed!'
                                       /*stick a fork in it,  we're all done. */
