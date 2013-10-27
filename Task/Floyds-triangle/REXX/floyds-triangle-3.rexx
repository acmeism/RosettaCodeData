/*REXX pgm displays Floyd's triangle for any number of rows  in base 16.*/
parse arg rows .; if rows==''  then rows=6   /*use 6 rows if not given. */
mV = rows * (rows+1) % 2                     /*calculate the max value. */
say 'displaying a'  rows  "row Floyd's triangle in base 16:";   say
#=1;              do     r=1  for rows;   i=0;       _=''
                      do #=#  for r;      i=i+1
                      _ = _ right(d2x(#),  length(d2x(mV-rows+i)))
                      end   /*#*/
                  say substr(_,2)            /*suppress a leading blank.*/
                  end       /*r*/
                                       /*stick a fork in it, we're done.*/
