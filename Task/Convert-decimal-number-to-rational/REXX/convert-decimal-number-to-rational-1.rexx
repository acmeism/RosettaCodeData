/*REXX program converts a fraction [n/m] to it's simplest (lowest) terms*/
numeric digits 10                      /*use "only" 10 digs of precision*/
parse arg  orig 1 n.1  '/'  n.2;       if n.2=''  then n.2=1
if n.1=''  then call er 'no argument specified.'
         do i=1  for 2                 /*validate both args:  n.1  n.2  */
         if \datatype(n.i,'N')  then call er "argument isn't numeric:" n.i
         end   /*i*/
if n.2=0  then call er "divisor can't be zero."    /*whoa, dividing by 0*/
say 'old =' space(orig)                            /*display original.  */
say 'new =' rat(n.1/n.2)                           /*display the result.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ER subroutine───────────────────────*/
er:   say;   say '***error!***';    say;    say arg(1);    say;    exit 13
/*──────────────────────────────────RAT subroutine──────────────────────*/
rat:  procedure;   parse arg x 1 _x,y;    if y=='' then y=10**(digits()-1)
b=0;  g=0;  a=1;  h=1                              /*Y is the tolerance.*/
                           do  while  a<=y & g<=y;      n=trunc(_x)
                           _=a;   a=n*a+b;   b=_
                           _=g;   g=n*g+h;   h=_
                           if n=_x | a/g=x then do
                                                if a>y | g>y  then iterate
                                                b=a;     h=g;      leave
                                                end
                           _x= 1 / (_x-n)
                           end   /*while a≤y & g≤y*/
if h==1  then return b                 /*don't show number divided by 1 */
              return b'/'h             /*show a proper|improper fraction*/
