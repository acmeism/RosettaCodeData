/*REXX program applies a  callback  to an array  (using factorials for a demonstration).*/
numeric digits 100                               /*be able to display some huge numbers.*/
parse arg # .                                    /*obtain an optional value from the CL.*/
a.=                                              /*initialize the array  A  to all nulls*/
if #=='' | #==","  then #= 12                    /*Not assigned?  Then use default value*/
                        do j=0  to #;   a.j= j   /*assign the integer   J  ───►   A.j   */
                        end   /*j*/              /*array  A  will have N values: 0 ──► #*/

call listA   'before callback'                   /*display  A  array before the callback*/
say                                              /*display a blank line for readability.*/
say '      ··· applying callback to array A ···' /*display what is about to happen to B.*/
say                                              /*display a blank line for readability.*/
call bangit  'a'                                 /*factorialize (the values) of A array.*/
                                                 /*    store the results  ───►  array B.*/
call listA   ' after callback'                   /*display  A  array after the callback.*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
bangit:   do v=0;  $= value(arg(1)'.'v);  if $=='' then return  /*No value?  Then return*/
          call value arg(1)'.'v, fact($)         /*assign a value (a factorial) to array*/
          end    /*i*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
fact:   procedure; arg x;   != 1;         do f=2  to x;  != !*f;  end; /*f*/;     return !
listA:    do k=0  while a.k\=='';  say arg(1)  'a.'k"="  a.k;     end  /*k*/;     return
