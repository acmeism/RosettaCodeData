/*REXX program  writes (appends) two records,  closes the file,  appends another record.*/
signal on syntax;      signal on noValue         /*handle (if any)  REXX program errors.*/
tFID= 'PASSWD.TXT'                               /*define the name of the  output  file.*/
call lineout tFID                                /*close the output file,  just in case,*/
                                                 /*   it could be open from calling pgm.*/
call writeRec tFID,,                             /*append the  1st record  to the file. */
   'jsmith',"x", 1001, 1000, 'Joe Smith,Room 1007,(234)555-8917,(234)555-0077,jsmith@rosettacode.org', "/home/jsmith", '/bin/bash'

call writeRec tFID,,                             /*append the  2nd record  to the file. */
   'jdoe',  "x", 1002, 1000, 'Jane Doe,Room 1004,(234)555-8914,(234)555-0044,jdoe@rosettacode.org',    "/home/jsmith", '/bin/bash'

call lineout fid                                 /*close the outfile  (just to be tidy).*/

call writeRec tFID,,                             /*append the  3rd record  to the file. */
   'xyz',   "x", 1003, 1000, 'X Yz,Room 1003,(234)555-8913,(234)555-0033,xyz@rosettacode.org',         "/home/xyz",    '/bin/bash'
/*─account─pw────uid───gid──────────────fullname,office,extension,homephone,Email────────────────────────directory───────shell──*/

call lineout fid                                 /*"be safe" programming: close the file*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
err: say; say '***error***';  say;   do j=1  for arg();  say arg(j);  say;  end;   exit 13
s:   if arg(1)==1  then return arg(3);       return word(arg(2) 's', 1)     /*pluralizer*/
/*──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────*/
noValue:  syntax: call err 'REXX program' condition("C"), condition("D"), 'REXX source statement (line' sigl"):", sourceline(sigl)
/*──────────────────────────────────────────────────────────────────────────────────────*/
writeRec: parse arg fid,_                        /*get the fileID, and also the 1st arg.*/
          sep=':'                                /*field delimiter used in file, it ··· */
                                                 /*      ··· can be unique and any size.*/
                       do i=3  to arg()          /*get each argument and append it to   */
                       _=_ || sep || arg(i)      /*  the previous arg, with a   :   sep.*/
                       end   /*i*/

                       do tries=0  for 11        /*keep trying for  66  seconds.        */
                       r=lineout(fid, _)         /*write (append)  the new record.      */
                       if r==0  then return      /*Zero?   Then record was written.     */
                       call sleep tries          /*Error?  So try again after a delay.  */
                       end   /*tries*/           /*Note:  not all REXXes have  SLEEP.   */
          call err    r    'record's(r)    "not written to file"    fid;       exit 13
          /*some error causes: no write access, disk is full, file lockout, no authority*/
