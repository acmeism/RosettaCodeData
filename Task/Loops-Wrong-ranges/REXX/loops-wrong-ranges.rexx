/*REXX program demonstrates several versions of  DO  loops with  "unusual"  iterations. */
@.=;      @.1=  '  -2      2       1  '      /*"normal".                                */
          @.2=  '  -2      2       0  '      /*"normal",                zero  increment.*/
          @.3=  '  -2      2      -1  '      /*increases away from stop, neg  increment.*/
          @.4=  '  -2      2      10  '      /*1st increment > stop, positive increment.*/
          @.5=  '   2     -2       1  '      /*start > stop,         positive increment.*/
          @.6=  '   2      2       1  '      /*start equals stop,    positive increment.*/
          @.7=  '   2      2      -1  '      /*start equals stop,    negative increment.*/
          @.8=  '   2      2       0  '      /*start equals stop,       zero  increment.*/
          @.9=  '   0      0       0  '      /*start equals stop,       zero  increment.*/
zLim= 10                                     /*a limit to check for runaway (race) loop.*/
                                             /*a zero increment is not an error in REXX.*/
  do k=1  while  @.k\==''                    /*perform a  DO  loop with several ranges. */
  parse var   @.k    x  y  z  .              /*obtain the three values for a DO loop.   */
  say
  say center('start of performing DO loop number '   k   " with range: "  x y z,  79, '═')
  zz= 0
        do  j=x   to y   by z   until zz>=zLim           /* ◄───  perform the  DO  loop.*/
        say '   j ───►'  right(j, max(3, length(j) ) )   /*right justify J for alignment*/
        if z==0  then zz= zz + 1                         /*if zero inc, count happenings*/
        end   /*j*/

  if zz>=zLim  then say 'the DO loop for the '    k    " entry was terminated (runaway)."
  say center(' end  of performing DO loop number '   k   " with range: "  x y z,  79, '─')
  say
  end         /*k*/                              /*stick a fork in it,  we're all done. */
