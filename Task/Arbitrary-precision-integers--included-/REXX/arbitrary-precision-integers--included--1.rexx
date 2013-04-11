/*REXX program to calculate and demonstrate arbitrary precision numbers.*/
numeric digits 200000
check = 62060698786608744707...92256259918212890625
    n = 5 ** (4 ** (3 ** 2))           /*calc. multiple exponentations. */
sampl = left(n, 20)'...'right(n, 20)
say  ' check:'  check
say  'sample:'  sampl
say  'digits:'  length(n)
say
if check==sampl  then say 'passed!'
                 else say 'failed!'
                                       /*stick a fork in it, we're done.*/
