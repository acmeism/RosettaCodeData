/*REXX pgm constructs & displays Floyd's triangle for any number of rows*/
parse arg rows .;  if rows==''  then rows=5  /*use 5 rows if not given. */
mV = rows * (rows+1) % 2                     /*calculate the max value. */
say 'displaying a'  rows  "row Floyd's triangle:";   say
#=1;              do     r=1  for rows;   i=0;       _=''
                      do #=#  for r;      i=i+1
                      _ = _ right(#, length(mV-rows+i))
                      end   /*#*/
                  say _
                  end       /*r*/
                                       /*stick a fork in it, we're done.*/
