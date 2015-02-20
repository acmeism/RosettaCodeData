/*REXX pgm displays Floyd's triangle for any number of rows  in base 16.*/
parse arg rows .;  if rows==''  then rows=6 /*Not specified? Use default*/
maxV = rows * (rows+1) % 2                  /*calculate the max value.  */
say 'displaying a' rows "row Floyd's triangle in base 16:";   say  /*hdr*/
#=1;              do     r=1  for rows;   i=0;       _=    /*row by row.*/
                      do #=#  for r;      i=i+1            /*start a row*/
                      _ = _ right(d2x(#),  length(d2x(maxV - rows + i)))
                      end   /*#*/      /* [↑]  the triangle row is done.*/
                say substr(_,2)        /*suppress the 1st leading blank,*/
                end       /*r*/        /* [↑]   introduced by 1st abutt.*/
                                       /*stick a fork in it, we're done.*/
