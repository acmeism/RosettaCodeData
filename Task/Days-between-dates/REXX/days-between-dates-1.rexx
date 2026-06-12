/*REXX program computes the number of days between two dates in the form of  YYYY-MM-DD */
parse arg $1 $2 .                                /*get 2 arguments (dates) from the C.L.*/
say abs( date('B',$1,"I")  -  date('B',$2,"I") )   ' days between '    $1    " and "    $2
                                                 /*stick a fork in it,  we're all done. */
