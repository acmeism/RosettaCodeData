/*REXX pgm deletes a file & a folder in the current directory & the root*/
trace off                              /*suppress REXX error messages.  */
aFile= 'input.txt'                     /*name of a  file  to be deleted.*/
aDir = 'docs'                          /*name of a folder to be removed.*/
               do j=1  for 2           /*perform this  DO  loop twice.  */
               'ERASE'  aFile          /*erase this  file in the cur dir*/
               'RMDIR'  "/s /q"  aDir  /*remove the folder "  "   "   " */
               if j==1  then 'CD \'    /*make current dir  the root dir.*/
               end                     /* [↑]    just do    CD \   once.*/
                                       /*stick a fork in it, we're done.*/
