/*REXX program reads a specific line from a file  (and displays the length and content).*/
parse arg FID n .                                /*obtain optional arguments from the CL*/
if FID=='' | FID==","  then  FID= 'JUNK.TXT'     /*not specified?  Then use the default.*/
if   n=='' |   n==","  then    n=7               /* "      "         "   "   "      "   */

if lines(FID)==0  then  call ser "wasn't found." /*see if the file    exists  (or not). */

  do  n-1
  call linein FID                                /*read all the lines previous to  N.  */
  end   /*n-1*/

if lines(FID)==0  then  call ser "doesn't contain"       N        'lines.'
                                                 /* [↑]  any more lines to read in file?*/

$=linein(FID)                                    /*read the   Nth  record in the file.  */

say 'File '  FID  " line "  N  ' has a length of: '         length($)
say 'File '  FID  " line "  N  'contents: '   $  /*display the contents of the Nth line.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
ser:   say;     say '***error!***  File '     FID     " "    arg(1);      say;     exit 13
