/*REXX program to calculate and demonstrate arbitrary precision numbers.*/
numeric digits 5                       /*set to low precision for speed.*/
check = 62060698786608744707...92256259918212890625

                  n=5** (4** (3** 2))  /*calc. multiple exponentations. */

parse var n 'E' pow .                  /*POW might be null, so  N is OK.*/

if pow\==''  then do                   /*general case:  POW might be < 0*/
                  numeric digits abs(pow)+9  /*recalc. with more digits.*/
                  n=5** (4** (3** 2))  /*calc. multiple exponentations. */
                  end

sampl = left(n, 20)'...'right(n, 20)
say  ' check:'  check
say  'sample:'  sampl
say  'digits:'  length(n)
say
if check==sampl  then say 'passed!'
                 else say 'failed!'
                                       /*stick a fork in it, we're done.*/
