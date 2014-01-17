/*REXX program demonstrates a  DO WHILE  with index reduction construct.*/
x=1024                                 /*define the initial value of  X.*/
        do  while  x>0                 /*test if made at the top of  DO.*/
        say right(x,10)                /*pretty output by aligning right*/
        x=x%2                          /*in REXX, % is integer division.*/
        end
                                       /*stick a fork in it, we're done.*/
