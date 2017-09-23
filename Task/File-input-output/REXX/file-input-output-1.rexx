/*REXX program reads a file and copies the contents into an output file  (on a line by line basis).*/
iFID =  'input.txt'                              /*the name of the   input  file.       */
oFID = 'output.txt'                              /* "    "   "  "   output    "         */
call lineout iFID,,1                             /*insure the  input starts at line one.*/      /* ◄■■■■■■ optional.*/
call lineout oFID,,1                             /*   "    "  output    "    "   "   "  */      /* ◄■■■■■■ optional.*/

  do  while lines(iFID)\==0;    $=linein(iFID)   /*read records from input 'til finished*/
             call lineout oFID, $                /*write the record just read ──► output*/
  end   /*while*/                                /*stick a fork in it,  we're all done. */

call lineout iFID                                /*close   input  file, just to be safe.*/      /* ◄■■■■■■ best programming practice.*/
call lineout oFID                                /*  "    output    "     "   "  "   "  */      /* ◄■■■■■■ best programming practice.*/
