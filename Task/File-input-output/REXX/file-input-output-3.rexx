/*REXX program to read a file and write contents to an output file*****
* 03.09.2012 Walter Pachl (without erase string would be appended)
**********************************************************************/
ifid='input.txt'                        /*name of the  input file.   */
ofid='output.txt'                       /*name of the output file.   */
'erase' ofid                            /* avoid appending           */
s=charin(ifid,,1000000)                 /* read the input file       */
Call charout ofid,s                     /* write to output file      */
