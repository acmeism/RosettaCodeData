/*REXX program prints a string to the  (DOS) line printer  via redirection to a printer.*/
$= 'Hello World!'                                /*define a string to be used for output*/
'@ECHO'   $    ">PRN"                            /*stick a fork in it,  we're all done. */
