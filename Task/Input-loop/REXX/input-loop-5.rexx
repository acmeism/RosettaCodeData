/*REXX program reads from the (console) default input stream until null*/

       do  until _==''
       _=linein()
       end   /*until ...*/
exit                                   /*stick a fork in it, we're done.*/
