/*REXX program  creates a  directory (folder)  and all its  parent paths  as necessary. */
trace off                                              /*suppress possible warning msgs.*/

dPath = 'path\to\dir'                                  /*define directory (folder) path.*/

'MKDIR'  dPath  "2>nul"                                /*alias could be used:  MD dPath */
                                                       /*stick a fork in it, we're done.*/
