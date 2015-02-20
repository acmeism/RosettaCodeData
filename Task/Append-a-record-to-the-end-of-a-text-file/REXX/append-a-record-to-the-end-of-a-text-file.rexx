/*REXX pgm:  writes two records,  close file,  appends another record.  */
signal on syntax;  signal on novalue   /*handle REXX program errors.    */
tFID='PASSWD.TXT'                      /*define the name of the out file*/
call lineout tFID                      /*close the file, just in case;  */
                                       /*could be open from calling pgm.*/
call writeRec tFID,,                   /*append 1st record to the file. */
   'jsmith',"x", 1001, 1000, 'Joe Smith,Room 1007,(234)555-8917,(234)555-0077,jsmith@rosettacode.org', "/home/jsmith", '/bin/bash'

call writeRec tFID,,                   /*append 2nd record to the file. */
   'jdoe',  "x", 1002, 1000, 'Jane Doe,Room 1004,(234)555-8914,(234)555-0044,jdoe@rosettacode.org',    "/home/jsmith", '/bin/bash'

call lineout fid                       /*close the file.                */

call writeRec tFID,,                   /*append 3rd record to the file. */
   'xyz',   "x", 1003, 1000, 'X Yz,Room 1003,(234)555-8913,(234)555-0033,xyz@rosettacode.org',         "/home/xyz",    '/bin/bash'
/*─account─pw────uid───gid──────────────fullname,office,extension,homephone,Email────────────────────────directory───────shell──*/

call lineout fid                       /*safe programming:  close file. */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────WRITEREC subroutine─────────────────*/
writeRec: parse arg fid,_              /*get the fileID, and the 1st arg*/
sep=':'                                /*field delimiter used in file.  */
                                       /*Note:  SEP field should be ··· */
                                       /*··· unique and can be any size.*/
                    do i=3 to arg()    /*get each argument and append it*/
                    _=_ ||sep|| arg(i) /*to the prev. arg, with a : sep.*/
                    end   /*i*/

   do tries=0 for 11                   /*keep trying for 66 seconds.    */
   r=lineout(fid,_)                    /*write (append) the new record. */
   if r==0  then return                /*Zero?  Then record was written.*/
   call sleep tries                    /*Error: so try again after delay*/
   end   /*tries*/                     /*Note: not all REXXes have SLEEP*/

                                       /*possibly:  no write access,    */
                                       /*           proper authority,   */
                                       /*           permission,  etc.   */
call err r 'record's(r) "not written to file" fid
exit 13
/*───────────────────────────────error handling subroutines and others.─*/
err: say; say;  say center(' error! ',40,"*");   say
                do j=1  for arg();  say arg(j);  say; end;  say;   exit 13

novalue: syntax: call err 'REXX program' condition('C') "error",,
             condition('D'),'REXX source statement (line' sigl"):",,
             sourceline(sigl)

s: if arg(1)==1 then return arg(3);return word(arg(2) 's',1)
