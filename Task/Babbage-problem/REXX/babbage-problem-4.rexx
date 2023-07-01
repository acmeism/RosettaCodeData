/*REXX ----------------------------------------------------------------
* The solution must actually be larger than sqrt(269696)=519.585
*--------------------------------------------------------------------*/
z=0
Do i=524 By 10 Until z>0
  If right(i*i,6)==269696  then z=i
  Else Do
   j=i+2
   if right(j*j,6)==269696  then z=j
   End
 End
Say "The smallest integer whose square ends in 269696 is:" z
Say '                            'z'**2 =' z**2
