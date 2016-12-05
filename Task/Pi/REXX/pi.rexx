/*REXX program spits out decimal digits of pi  (one digit at a time)  until  Ctrl-Break.*/
parse arg digs oFID .                            /*obtain optional argument from the CL.*/
if digs=='' | digs==","  then digs=1e6           /*Not specified?  Then use the default.*/
if oFID=='' | oFID==","  then oFID='PI_SPIT.OUT' /* "      "         "   "   "      "   */
numeric digits digs                              /*with bigger digs, spitting is slower.*/
call time 'Reset'                                /*reset the wall─clock (elapsed) timer.*/
signal on halt                                   /*───► HALT when Ctrl─Break is pressed.*/
pi=0;  v=5;   vv=v*v;   g=239;   gg=g*g;  spit=0 /*assign some values to some variables.*/
s=16                                             /*calculate π with increasing accuracy */
r=4;    do n=1  by 2  until  old=pi;      old=pi /*just calculate  pi  with odd integers*/
        pi=pi + s/(n*v) - r/(n*g)                /*    ···  using John Machin's formula.*/
        if pi==old  then leave                   /*have we exceeded the DIGITS accuracy?*/
        s=-s;             r=-r;  v=v*vv;  g=g*gg /*compute some variables for shortcuts.*/
                 do j=spit+1  to compare(pi,old) /*spit out some (new)  digits of π (pi)*/
                 parse var  pi  =(j)  spit  +1   /*equivalent to:   spit=substr(pi,j,1) */
                 call charout     ,spit          /*display one (new) decimal digit of π.*/
                 call charout oFID,spit          /*··· and also write π digit to a file.*/
                 end   /*j*/                     /* [↑]  0, 1, or 2 decimal dig are spit*/
        spit=j-1                                 /*adjust for  DO  loop index increment.*/
        end            /*n*/
say                                              /*stick a fork in it,  we're all done. */
exit: say;  say n%2+1  'iterations took'  format(time("Elapsed"),,2)  'seconds.';     exit
halt: say;  say 'PI_SPIT halted via use of Ctrl-Break.';  signal exit /*show iterations.*/
