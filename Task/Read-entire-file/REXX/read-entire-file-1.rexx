/*REXX program reads an entire file line-by-line  and  stores it as a continuous string.*/
parse arg iFID .                                 /*obtain optional argument from the CL.*/
if iFID==''  then iFID= 'a_file'                 /*Not specified?  Then use the default.*/
$=                                               /*a string of file's contents (so far).*/
             do  while lines(iFID)\==0           /*read the file's lines until finished.*/
             $=$ || linein(iFID)                 /*append a (file's) line to the string,*/
             end   /*while*/                     /*stick a fork in it,  we're all done. */
