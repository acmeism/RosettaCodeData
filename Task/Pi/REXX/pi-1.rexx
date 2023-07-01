/*REXX program spits out decimal digits of pi  (one digit at a time)  until  Ctrl─Break.*/
parse arg digs oFID .                            /*obtain optional argument from the CL.*/
if digs=='' | digs==","  then digs= 1e6          /*Not specified?  Then use the default.*/
if oFID=='' | oFID==","  then oFID='PI_SPIT.OUT' /* "      "         "   "   "      "   */
write= digs<0                                    /*if ODIGS is <0, also spit pi to file.*/
numeric digits abs(digs) + 4                     /*with bigger digs, spitting is slower.*/
call time 'Reset'                                /*reset the wall─clock (elapsed) timer.*/
signal on halt                                   /*───► HALT when Ctrl─Break is pressed.*/
spit= 0                                          /*the index of the spitted pi dec. digs*/
pi=0;  v=5;   vv=v*v;   g=239;   gg=g*g;  s= 16  /*assign some values to some variables.*/
r= 4                                             /*calculate π with increasing accuracy */
      do n=1  by 2  until  old=pi;      old= pi  /*just calculate  pi  with odd integers*/
      pi= pi   +   s / (n*v)    -    r / (n*g)   /*    ···  using John Machin's formula.*/
      s= -s;    r= -r;    v= v * vv;   g= g * gg /*compute some variables for shortcuts.*/
      if n>3     then spit= spit + 1             /*maintain a lag for pi digits rounding*/
      if spit<4  then iterate                    /*Not enough digs yet?  Then don't show*/
      $= substr(pi, spit-3, 1)                   /*lag behind the true pi calculation.  */
                    call charout     , $         /*write the spitted digits to the term.*/
      if write then call charout oFID, $         /*  "    "     "      "     "  a  file?*/
      end   /*n*/

$= substr(pi, spit - 2);   L= length($) - 4      /*handle any residual decimal digits.  */
if L>0  then do                                  /*if any residual digits, then show 'em*/
                           call charout     , substr($, 1, L)         /*write to term.  */
             if write then call charout oFID, substr($, 1, L)         /*  "    " file?  */
             end
say                                              /*stick a fork in it,  we're all done. */
exit: say;  say n%2+1  'iterations took'  format(time("Elapsed"),,2)  'seconds.';   exit 0
halt: say;  say 'PI_SPIT halted via use of Ctrl─Break.';  signal exit /*show iterations.*/
