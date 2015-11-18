/*REXX program uses a C.L. command to invoke Windows SAM for speech synthesis.*/
parse arg t;  t=space(t)               /*get the (optional) text from the C.L.*/
if t==''  then signal done             /*Nothing to say?    Then exit program.*/

homedrive=value('HOMEDRIVE',,'SYSTEM') /*get  HOMEDRIVE  location of   \TEMP  */
tmp      =value('TEMP',,'SYSTEM')      /* "     TEMP     directory name.      */
if homedrive==''  then homedrive='C:'  /*use the default if none was found.   */
if tmp==''  then tmp=homedrive'\TEMP'  /* "   "     "     "   "   "    "      */
                                       /*code could be added here to get a ···*/
                                       /* ··· unique name for the  TEMP  file.*/
tFN='SPEAK_IT';     tFT='$$$'          /*use this name for the  TEMP's fileID.*/
tFID=homedrive||'\TEMP\' || tFN"."tFT  /*create temporary name for the output.*/
call lineout tFID,t                    /*write text ──► temporary output file.*/
call lineout tFID                      /*close the output file just to be neat*/
'NIRCMD'  "speak file"  tFID           /*NIRCMD  invokes Microsoft's Sam voice*/
'ERASE'   tFID                         /*clean up (delete)  the   TEMP   file.*/

done:                                  /*stick a fork in it,  we're all done. */
