/*REXX program creates a directory and all its parent paths as necessary*/
trace off                              /*suppress possible warning msgs.*/
dPath = 'path\to\dir'
'MKDIR'  dPath  "2>nul"                /*alias could be used:  MD Dpath */
                                       /*stick a fork in it, we're done.*/
