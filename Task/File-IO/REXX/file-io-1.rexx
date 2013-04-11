/*REXX program to read a file and store the contents into an output file*/

ifid = 'input.txt'                     /*name of the  input file.       */
ofid = 'output.txt'                    /*name of the output file.       */
call lineout ofid,,1                   /*insure output starts at line 1.*/

  do  while lines(ifid)\==0            /*read until finished.           */
  y =  linein(ifid)                    /*read a record from input.      */
  call lineout ofid,y                  /*write a record  to  output.nt. */
  end
                                       /*stick a fork in it, we're done.*/
