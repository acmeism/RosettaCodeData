/*──────────────────────────────────SQRT subroutine─────────────────────*/
sqrt: procedure;  arg x                /*a simplistic  SQRT  subroutine.*/
if x=0  then return 0                  /*handle special case of zero.   */
d=digits()                             /*get the current precision (dig)*/
numeric digits d+2                     /*ensure extra precision (2 digs)*/
g=x/4                                  /*try get a so-so 1st guesstimate*/
old=0                                  /*set OLD guess to zero.         */
                  do forever           /*keep at it 'til  G (guess)=old.*/
                  g=(g+x/g) / 2        /*do the nitty-gritty calculation*/
                  if g=old  then leave /*if G is the same as old, quit. */
                  old=g                /*save OLD for next iteration.   */
                  end   /*forever*/    /* [↑] ···'til we run out of digs*/
numeric digits d                       /*restore the original precision.*/
return g/1                             /*normalize to old precision (d).*/
