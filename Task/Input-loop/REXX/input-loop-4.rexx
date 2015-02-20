/*REXX program reads from the (console) default input stream until null*/

       do  until _==''
       parse pull _
       end   /*until ...*/
exit                                   /*stick a fork in it, we're done.*/
