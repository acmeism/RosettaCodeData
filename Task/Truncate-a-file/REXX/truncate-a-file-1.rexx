/*REXX program  truncates  a file  to a  specified  (and smaller)  number of bytes.     */
parse arg siz FID                                /*obtain required arguments from the CL*/
FID=strip(FID)                                   /*elide  FID  leading/trailing blanks. */
if siz==''             then call ser "No truncation size was specified  (1st argument)."
if FID==''             then call ser "No fileID was specified  (2nd argument)."
if \datatype(siz,'W')  then call ser "trunc size isn't an integer: "          siz
if siz<1               then call ser "trunc size isn't a positive integer: "  siz
_=charin(FID,1,siz+1)                            /*position file and read a wee bit more*/
#=length(_)                                      /*get the length of the part just read.*/
if #==0                then call ser "the specified file doesn't exist: "     FID
if #<siz               then call ser "the file is smaller than trunc size: "   #
call lineout FID                                 /*close the file used, just to be safe.*/
'ERASE'      FID                                 /*invoke a command to delete the file  */
call lineout FID                                 /*close the file, maybe for REXX's use.*/
call charout FID, left(_,siz), 1                 /*write a truncated version of the file*/
call lineout FID                                 /*close the file used, just to be safe.*/
say 'file '  FID " truncated to "  siz  'bytes.' /*display some information to terminal.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
ser:  say '***error***'  arg(1);      exit 13    /*display an error message  and  exit. */
