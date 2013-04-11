/*REXX program to read a file and store it as a continuous char string. */

iFID = 'a_file'                        /*name of the input file.        */
aString =

  do  while lines(iFID)\==0            /*read until finished.           */
  aString = aString || linein(iFID)    /*append input to  Astring.      */
  end   /*while*/
                                       /*stick a fork in it, we're done.*/
