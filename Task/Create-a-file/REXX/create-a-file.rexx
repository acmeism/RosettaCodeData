/*REXX pgm creates a new empty file and directory; in curr dir and root.*/
       do 2                            /*perform three statements twice.*/
       'COPY NUL output.txt'           /*copy a "null" (empty) file.    */
       'MKDIR DOCS'                    /*make a directory (aka: folder).*/
       'CD \'                          /*change currect dir to the root.*/
       end   /*2*/                     /*now, go and perform them again.*/
                                       /*stick a fork in it, we're done.*/
