/*REXX program mimics an  "approximately equal to"  for comparing floating point numbers*/
numeric digits 15                                /*what other FP hardware normally uses.*/
@.=                                              /*assign default for the   @   array.  */
parse arg @.1                                    /*obtain optional argument from the CL.*/
if @.1=''  |  @.1==","  then do;   @.1= 100000000000000.01           100000000000000.011
                                   @.2= 100.01                       100.011
                                   @.3= 10000000000000.001 / 10000   1000000000.0000001000
                                   @.4= 0.001                        0.0010000001
                                   @.5= 0.00000000000000000000101    0.0
                                   @.6=  sqrt(2) * sqrt(2)           2.0
                                   @.7= -sqrt(2) * sqrt(2)           '-2.0'
                                   @.8= 3.14159265358979323846       3.14159265358979324
          /* added ───► */         @.9= 100000000000000003.0         100000000000000004.0
                             end
     do j=1  while @.j\==''                      /*process CL argument or the array #s. */
     say
     say center(' processing pair ' j" ",71,'═') /*display a title for the pair of #s.  */
     parse value  @.j  with  a  b                /*extract two values from a pair of #s.*/
     say 'A='   a                                /*display the value of  A  to the term.*/
     say 'B='   b                                /*   "     "    "    "  B   "  "    "  */
     say right('A approximately equal to B?', 65)   word("false true", 1 + approxEQ(a,b) )
     end   /*j*/                                 /* [↑]  right─justify text & true/false*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
approxEQ: procedure; parse arg x,y;   return x=y /*floating point compare with 15 digits*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x;  if x=0  then return 0;  d=digits();  numeric digits;  h=d+6
      numeric form; m.=9; parse value format(x,2,1,,0) 'E0' with g "E" _ .; g=g *.5'e'_ %2
        do j=0  while h>9;      m.j=h;               h=h%2+1;       end  /*j*/
        do k=j+5  to 0  by -1;  numeric digits m.k;  g=(g+x/g)*.5;  end  /*k*/; return g/1
