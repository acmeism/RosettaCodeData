/*REXX program spits out digits of pi (one at a time) until  Ctrl-Break.*/
arg digs .; if digs==''  then digs=1e6 /*allow the specification of digs*/
fn = 'PI_DIGITS.OUT'                   /*file used for output: PI digits*/
numeric digits digs                    /*big digs, the slower the spits.*/
pi=0;   s=16;   r=4;   v=5;   vs=v*v;  g=239;  gg=g*g; j=1;  spit=0;  old=
call time 'Reset'                      /*reset the REXX wall-clock timer*/
                                       /*───calculate PI with increasing*/
  do n=1  by 2                         /*───accuracy (up to DIGS digits)*/
  pi=pi + s/(n*v) - r/(n*g)            /*───using John Machin's formula.*/
  if pi==old  then leave               /*have exceeded DIGITS accuracy. */
  s=-s;     r=-r;     v=v*vs;   g=g*gg /*set some variable for shortcuts*/
  if n\==1  then do j=spit+1  to compare(pi,old)  /*spit out some π digs.*/
                 spit=substr(pi,j,1)   /*obtain a digit of π to spit out*/
                 call charout   ,spit  /*spit out one (new) digit of pi.*/
                 call charout fn,spit  /* ···and also echo it to a file.*/
                 end   /*j*/
  spit=j-1                             /*adjust for  DO index increment.*/
  old=pi                               /*use the "OLD" value next time. */
  end   /*n*/

say;  say n%2+1  'iterations took'  format(time("Elapsed"),,2)  'seconds.'
                                       /*stick a fork in it, we're done.*/
