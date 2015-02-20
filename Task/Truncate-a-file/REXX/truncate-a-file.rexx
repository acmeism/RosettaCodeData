/*REXX program  truncates  a file  to a specified number of bytes.      */
parse arg siz FID                      /*get arguments from the C.L.    */
FID=strip(FID)                         /*strip leading/trailing blanks. */
if FID==''             then call ser "No fileID specified"
if \datatype(siz,'W')  then call ser "trunc size isn't an integer: "  siz
if siz<1               then call ser "trunc size isn't a positive integer"
call charin FID,1,0                    /*position the file, just in case*/
                    do #=1  while lines(FID)\==0 & #<=siz
                    call charin FID    /*read a single byte at a time.  */
                    end   /*#*/        /*read file, ensure it's big 'nuf*/
#=#-1                                  /*adjust for the  DO  loop index.*/
if #==0                then call ser "the specified file doesn't exist"
if #<siz               then call ser "the file is smaller than trunc size"
_=charin(FID,1,siz)                    /*read just enough of the file.  */
call lineout FID                       /*close the file, just to be sure*/
'ERASE'  FID                           /*invoke a command to delete file*/
call lineout FID                       /*close the file, just to be neat*/
call charout FID,_,1                   /*write a smaller version of file*/
call lineout FID                       /*close the file, just to be safe*/
say 'file '    FID    " truncated to "   siz   'bytes.'      /*show info*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SER subroutine──────────────────────*/
ser:  say '***error!***'  arg(1)".";  exit 13
