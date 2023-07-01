if  y  then @=6                        /* Y  must be either   0  or  1  */

if t**2>u  then x=y                    /*simple  IF  with  THEN & ELSE. */
           else x=-y

if t**2>u  then do j=1  for 10;  say prime(j);  end    /*THEN  DO  loop.*/
           else x=-y                                   /*simple  ELSE.  */

if z>w+4  then do                                      /*THEN  DO group.*/
               z=abs(z)
               say 'z='z
               end
          else do;  z=0;  say 'failed.';  end          /*ELSE  DO group.*/

if x>y  &  c*d<sqrt(pz) |,             /*this statement is continued [,]*/
   substr(abc,4,1)=='~'  then  if  z=0  then call punt
                                        else nop       /*NOP pairs up IF*/
                         else  if  z<0  then z=-y      /*alignment helps*/
