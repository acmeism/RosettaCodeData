/*REXX program demonstrates a  DO WHILE  with index reduction construct.*/
j=1024                                 /*define the initial value of  J.*/
        do  while  j>0                 /*test if made at the top of  DO.*/
        say j
        j=j%2                          /*in REXX, % is integer division.*/
        end
                                       /*stick a fork in it, we're done.*/
