/*REXX program deletes a file and a folder in the  current directory  and  the root.    */
trace off                                        /*suppress REXX error messages from DOS*/
aFile= 'input.txt'                               /*name of a  file  to be deleted.      */
aDir = 'docs'                                    /*name of a folder to be removed.      */
               do j=1  for 2                     /*perform this  DO  loop exactly twice.*/
               'ERASE'  aFile                    /*erase this  file in the current dir. */
               'RMDIR'  "/s /q"  aDir            /*remove the folder "  "     "     "   */
               if j==1  then 'CD \'              /*make the  current dir  the  root dir.*/
               end                               /* [↑]  just do   CD \    command once.*/
                                                 /*stick a fork in it,  we're all done. */
