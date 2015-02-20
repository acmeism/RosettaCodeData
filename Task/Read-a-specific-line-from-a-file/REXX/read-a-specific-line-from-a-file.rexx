/*REXX program to read a  specific line  from a file.                   */
parse arg fileId n .                   /*get the user args:  fileid  n  */
if fileID==''  then fileId='JUNK.TXT'  /*assume fileID default: JUNK.TXT*/
if      n==''  then n=7                /*assume    N   default:     7   */
L=lines(fileid)                        /*first, see if the file exists. */
if L==0  then  do;   say 'error, fileID not found:' fileId;   exit;   end
q=linein(fileId, n)                    /*read the Nth line, store in  Q.*/
if length(q)==0  then say 'line'     n     "not found."
                 else say 'file'  fileId   "record"      n   '='   q
                                       /*stick a fork in it, we're done.*/
