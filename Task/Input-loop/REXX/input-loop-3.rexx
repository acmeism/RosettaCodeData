/*REXX program to read from the (console) default input stream until nul*/

       do  until _==''
       parse pull _
       end   /*until ...*/
exit                                   /*stick a fork in it, we're done.*/
