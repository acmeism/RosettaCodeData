/*REXX program to read a file and store the contents into an output file*/
/*(same as the 1st example, but is faster because no intermediate step.)*/

ifid = 'input.txt'                     /*name of the  input file.       */
ofid = 'output.txt'                    /*name of the output file.       */
call lineout ofid,,1                   /*insure output starts at line 1.*/

  do  while lines(ifid)\==0            /*read until finished.           */
  call lineout ofid, linein(ifid)      /*read & write in one statement. */
  end   /*while*/
                                       /*stick a fork in it, we're done.*/
