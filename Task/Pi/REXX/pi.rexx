/*REXX program spits out digits of  π (pi)  (one at a time)  until Ctrl-Break.*/
parse arg digs .                       /*obtain optional argument from the CL.*/
if digs==''  | digs=="," then digs=1e6 /*Not specified?  Then use one million.*/
fn = 'PI_DIGITS.OUT'                   /*fileID used for output: the π digits.*/
numeric digits digs                    /*with bigger digs, spitting is slower.*/
call time 'Reset'                      /*reset the wall-clock (elapsed) timer.*/
signal on halt                         /*───► HALT when Ctrl─Break is pressed.*/
pi=0;    s=16;    r=4;    v=5;    vv=v*v;    g=239;    gg=g*g;    spit=0;   old=

    do n=1  by 2                       /*calculate π with increasing accuracy */
    pi=pi + s/(n*v) - r/(n*g)          /*    ···  using John Machin's formula.*/
    if pi==old  then leave             /*have we exceeded the DIGITS accuracy?*/
    s=-s;   r=-r;    v=v*vv;   g=g*gg  /*compute some variables for shortcuts.*/
       do j=spit+1  to compare(pi,old) /*spit out some (new)  digits of π (pi)*/
       parse var  pi  =(j)  spit  +1   /*equivalent to:   spit=substr(pi,j,1) */
       call charout   ,spit            /*display one (new) decimal digit of π.*/
       call charout fn,spit            /*··· and also write π digit to a file.*/
       end   /*j*/                     /* [↑]  0, 1, or 2 decimal dig are spit*/
    spit=j-1                           /*adjust for  DO  loop index increment.*/
    old=pi                             /*use "OLD" value for the next COMPARE.*/
    end      /*n*/
say                                    /*stick a fork in it,  we're all done. */
halt:   say  n%2+1   'iterations took'   format(time("Elapsed"),,2)   'seconds.'
