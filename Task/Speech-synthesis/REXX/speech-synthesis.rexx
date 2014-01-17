/*REXX pgm uses a CLI cmd to invoke Windows/XP SAM for speech synthesis.*/
parse arg t;  t=space(t)               /*get the (optional) text from CL*/
if t==''  then exit                    /*Nothing to say?  Then exit pgm.*/
homedrive=value('HOMEDRIVE',,'SYSTEM') /*get HOMEDRIVE location of \TEMP*/
tmp      =value('TEMP',,'SYSTEM')      /* "    TEMP    directory name.  */
if homedrive==''  then homedrive='C:'  /*use default if none found.     */
if tmp==''  then tmp=homedrive'\TEMP'  /* "     "     "   "    "        */
                                       /*code could be added here to get*/
                                       /*a unique name for the TEMP file*/
tFN='SPEAK_IT';     tFT='$$$'          /*use this for the TEMP's fileID.*/
tFID=homedrive||'\TEMP\' || tFN"."tFT  /*create temp name for the output*/
call lineout tFID,t                    /*write text──►a temp output file*/
call lineout tFID                      /*close the file just to be neat.*/
'NIRCMD'  "speak file"  tFID           /*NIRCMD invokes the MS Sam voice*/
'ERASE' tfid                           /*clean up (delete) the TEMP file*/
                                       /*stick a fork in it, we're done.*/
