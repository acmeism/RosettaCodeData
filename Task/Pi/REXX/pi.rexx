/*REXX program to spit out pi digits (few at a time) until  Ctrl-Break. */

arg digs .; if digs=='' then digs=1e6  /*allow the specification of digs*/
fn='PI_DIGITS.OUT'                     /*file that can be written to.   */
numeric digits digs                    /*big digs, the slower the spits.*/
pi=0;  s=16;  r=4;  v=5;  vs=v*v;  g=239;  gs=g*g;  old=;  spewed=0;  j=1
call time 'E'

/*─────────────────────────────────────John Machin's formula for  pi.   */
  do n=1  by 2
  pi=pi + s/(n*v) - r/(n*g)
  if pi==old  then leave               /*no further with current DIGITS.*/
  s=-s;  r=-r;  v=v*vs;  g=g*gs
  if n\==1  then do j=spewed+1  to compare(pi,old)
                 spit=substr(pi,j,1)
                 call charout   ,spit          /*spit out 1 digit of pi.*/
                 call charout fn,spit          /* ...and also to a file.*/
                 end
  spewed=j-1
  old=pi
  end   /*n*/

say;    say  n%2+1   'iterations took'   format(time("E"),,2)   'seconds.'
                                       /*stick a fork in it, we're done.*/
