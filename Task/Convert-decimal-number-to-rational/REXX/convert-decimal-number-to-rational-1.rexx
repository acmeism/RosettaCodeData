/*REXX program converts a rational fraction  [n/m]  (or  nnn.ddd)  to it's lowest terms.*/
numeric digits 10                                /*use ten decimal digits of precision. */
parse arg  orig 1 n.1  "/"  n.2;       if n.2=''  then n.2=1         /*get the fraction.*/
if n.1=''  then call er 'no argument specified.'

  do j=1  for 2;     if \datatype(n.j, 'N')  then call er  "argument isn't numeric:"   n.j
  end   /*j*/                                    /* [↑]  validate arguments:  n.1  n.2  */

if n.2=0  then call er "divisor can't be zero."  /*Whoa!   We're dividing by zero !     */
say 'old ='    space(orig)                       /*display the original fraction.       */
say 'new ='    rat(n.1/n.2)                      /*display the result ──► terminal.     */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
er:  say;      say '***error***';     say;    say arg(1);    say;       exit 13
/*──────────────────────────────────────────────────────────────────────────────────────*/
rat: procedure;  parse arg x 1 _x,y;          if y==''  then y = 10**(digits()-1)
     b=0;  g=0;  a=1;  h=1                               /* [↑]    Y   is the tolerance.*/
                            do  while  a<=y & g<=y;   n=trunc(_x)
                            _=a;   a=n*a+b;   b=_
                            _=g;   g=n*g+h;   h=_
                            if n=_x | a/g=x then do;  if a>y | g>y  then iterate
                                                      b=a;     h=g;      leave
                                                 end
                            _x=1/(_x-n)
                            end   /*while*/
     if h==1  then return b                              /*don't return number  ÷  by 1.*/
                   return b'/'h                          /*proper or improper fraction. */
