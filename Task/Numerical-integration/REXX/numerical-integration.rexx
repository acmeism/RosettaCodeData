/*REXX pgm performs numerical integration using 5 different algorithms and show results.*/
numeric digits 20                                /*use twenty decimal digits precision. */

     do test=1  for 4                            /*perform the 4 different test suites. */
     if test==1  then do;  L=0;   H=   1;   i=    100;   end
     if test==2  then do;  L=1;   H= 100;   i=   1000;   end
     if test==3  then do;  L=0;   H=5000;   i=5000000;   end
     if test==4  then do;  L=0;   H=6000;   i=5000000;   end
     say
     say center('test' test,65,'─')              /*display a header for the test suite. */
     say '      left rectangular('L", "H', 'i")  ──► "        left_rect(L, H, i)
     say '  midpoint rectangular('L", "H', 'i")  ──► "    midpoint_rect(L, H, i)
     say '     right rectangular('L", "H', 'i")  ──► "       right_rect(L, H, i)
     say '               Simpson('L", "H', 'i")  ──► "          Simpson(L, H, i)
     say '             trapezium('L", "H', 'i")  ──► "        trapezium(L, H, i)
     end   /*test*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
f:   if test==1  then return arg(1)**3           /*choose the    cube     function.     */
     if test==2  then return 1/arg(1)            /*   "    "  reciprocal     "          */
                      return arg(1)              /*   "    "    "as-is"      "          */
/*──────────────────────────────────────────────────────────────────────────────────────*/
left_rect:     procedure expose test;  parse arg a,b,n;              h=(b-a)/n
               $=0
                               do x=a  by h  for n;      $=$+f(x);   end  /*x*/
               return $*h/1
/*──────────────────────────────────────────────────────────────────────────────────────*/
midpoint_rect: procedure expose test;  parse arg a,b,n;              h=(b-a)/n
               $=0
                               do x=a+h/2  by h  for n;  $=$+f(x);   end  /*x*/
               return $*h/1
/*──────────────────────────────────────────────────────────────────────────────────────*/
right_rect:    procedure expose test;  parse arg a,b,n;              h=(b-a)/n
               $=0
                               do x=a+h    by h  for n;  $=$+f(x);   end  /*x*/
               return $*h/1
/*──────────────────────────────────────────────────────────────────────────────────────*/
Simpson:       procedure expose test;  parse arg a,b,n;              h=(b-a)/n
               $=f(a+h/2)
               @=0;            do x=1  for n-1; $=$+f(a+h*x+h*.5); @=@+f(a+x*h); end /*x*/

               return h*(f(a) + f(b) + 4*$ + 2*@)  /  6
/*──────────────────────────────────────────────────────────────────────────────────────*/
trapezium:     procedure expose test;   parse arg a,b,n;              h=(b-a)/n
               $=0
                               do x=a  by h  for n;      $=$+(f(x)+f(x+h));  end  /*x*/
               return $*h/2
