/*REXX program reads a file and stores it as a continuous character str.*/
iFID = 'a_file'                        /*name of the input file.        */
aString =                              /*value of file's contents so far*/
                                       /* [↓]  read file  line-by-line. */
  do  while  lines(iFID) \== 0         /*read file's lines 'til finished*/
  aString = aString || linein(iFID)    /*append a (file) line to aString*/
  end   /*while*/
                                       /*stick a fork in it, we're done.*/
