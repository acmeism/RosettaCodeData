/*REXX pgm constructs & displays Floyd's triangle for any number of rows*/
parse arg rows .;  if rows==''  then rows=5 /*Not specified? Use default*/
maxV = rows * (rows+1) % 2                  /*calculate the max value.  */
say 'displaying a'  rows  "row Floyd's triangle:";   say   /*show header*/
#=1;            do     r=1  for rows;   i=0;         _=    /*row by row.*/
                    do #=#  for r;      i=i+1              /*start a row*/
                    _ = _ right(#, length(maxV-rows+i))    /*build a row*/
                    end   /*#*/                            /*row is done*/
                say substr(_,2)        /*suppress the 1st leading blank,*/
                end       /*r*/        /* [↑]   introduced by 1st abutt.*/
                                       /*stick a fork in it, we're done.*/
