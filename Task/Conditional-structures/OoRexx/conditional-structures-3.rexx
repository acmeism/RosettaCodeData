if  y  then x=6                        /* Y must be either   0   or   1 */


if t**2>u then x=y
          else x=-y



if t**2>u then do j=1 to 10; say prime(j); end
          else x=-y



if z>w+4 then do
              z=abs(z)
              say 'z='z
              end
         else do;  z=0;  say 'failed.';  end



if x>y & c*d<sqrt(pz) |,
   substr(abc,4,1)=='@' then if z=0 then call punt
                                    else nop
                        else if z<0 then z=-y
