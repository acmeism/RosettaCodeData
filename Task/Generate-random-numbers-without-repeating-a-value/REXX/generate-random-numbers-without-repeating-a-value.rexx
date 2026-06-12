/*REXX program generates & displays a list of random integers (1 ──► N) with no repeats.*/
parse arg n cols seed .                          /*obtain optional argument from the CL.*/
if    n=='' |    n==","  then    n= 20           /*Not specified?  Then use the default.*/
if cols=='' | cols==","  then cols= 10           /* "      "         "   "   "     "    */
if datatype(seed, 'W')   then call random ,,seed /*Specified?      Then use the seed.   */
w= 6
                     title= ' random integers  (1 ──► '   n")  with no repeats"
say ' index │'center(title,   1 + cols*(w+1)     )         /*display the output title.  */
say '───────┼'center(""   ,   1 + cols*(w+1), '─')         /*   "     "     "  separator*/
a=
        do i=1  for n;      a= a  i              /*create a list of possible integers.  */
        end   /*i*/                              /*step through the (random) integers.  */
pool= n
        do r=1  for n;      ?= random(1, pool)   /*obtain a random integer from the list*/
        @.r= word(a, ?);    a= delword(a, ?, 1)  /*obtain random integer; del from pool.*/
        pool= pool - 1                           /*diminish size of the allowable pool. */
        end   /*r*/                              /*step through the (random) integers.  */
$=;                                     idx= 1
        do o=1  for n;      x= @.o               /*obtain a random integer from random @*/
        $= $  right( x, w)                       /*add an integer to the output list.   */
        if o//cols\==0  then iterate             /*have we populated a line of output?  */
        say center(idx, 7)'│'  substr($, 2); $=  /*display what we have so far  (cols). */
        idx= idx + cols                          /*bump the  index  count for the output*/
        end   /*j*/

if $\==''  then say center(idx, 7)"│"  substr($, 2)     /*possible show residual output.*/
say '───────┴'center(""  ,   1 + cols*(w+1), '─');  say
exit 0                                           /*stick a fork in it,  we're all done. */
