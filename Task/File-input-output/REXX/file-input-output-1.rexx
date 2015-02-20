/*REXX program to read a file and store the contents into an output file*/
iFID = 'input.txt'                     /*name of the  input file.       */
oFID = 'output.txt'                    /*name of the output file.       */
call lineout oFID,,1                   /*insure output starts at line 1.*/

  do  while lines(iFID)\==0            /*read records until finished.   */
  y =  linein(iFID)                    /*read  a record from input.     */
  call lineout oFID,y                  /*write a record  to  output.    */
  end   /*while ···*/
                                       /*stick a fork in it, we're done.*/
