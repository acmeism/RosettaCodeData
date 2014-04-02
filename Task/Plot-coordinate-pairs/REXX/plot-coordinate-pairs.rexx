/*REXX program plots coördinate pairs of numbers with plain characters. */
x = 0    1     2     3     4     5      6      7      8      9
y = 2.7  2.8  31.4  38.1  58.0  76.2  100.5  130.0  149.3  180.0
$=
                do j=1  for words(x)   /*build a list suitable for $PLOT*/
                $=$ word(x,j)','word(y,j)
                end   /*j*/            /*$≡  0,2.7   1,2.8   2,31.4  ···*/
call '$PLOT' $                         /*invoke the REXX program: $PLOT.*/
exit rc                                /*stick a fork in it, we're done.*/
