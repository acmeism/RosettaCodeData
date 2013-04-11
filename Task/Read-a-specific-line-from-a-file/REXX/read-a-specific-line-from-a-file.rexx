/*REXX program to read a  specific line  from a file.                   */
parse arg fileId n .                   /*get the user args:  fileid  n  */
if fileID==''  then fileId='JUNK.TXT'  /*assume the default:  JUNK.TXT  */
if      n==''  then n=7                /*assume the default  (n=7)      */
L=lines(fileid)                        /*first, see if the file exists. */
if L ==0  then  do;   say 'error, fileID not found:' fileId;   exit;   end
if n\==1  then call linein fileId,n-1  /*second, read previous rec. to N*/
L=lines(fileid)                        /* L =  # lines left in the file.*/
q=linein(fileId,n)                     /*read the Nth line, store in  Q.*/
qL=length(q)                           /*get the length of the record.  */
               select
               when L==0 & qL==0  then  say 'line' n "not found."
               when L==1 & qL==0  then  say 'line' n "has a zero length."
               otherwise                say 'file' fileId "record" n '=' q
               end   /*select*/
                                       /*stick a fork in it, we're done.*/
/*┌────────────────────────────────────────────────────────────────────┐
  │               ─── Normally, we could just use: ───                 │
  │                                                                    │
  │ q=linein(fileId,n)               /*read a specific record num. */  │
  │                                                                    │
  │── but  LINEIN  will just return a null when a record isn't found or│
  │   when the fileID doesn't exist,  or  N  is beyond the end-of-file.│
  │                                                                    │
  │── In the case of sparse files,  the record may not exist (be null).│
  └────────────────────────────────────────────────────────────────────┘*/
