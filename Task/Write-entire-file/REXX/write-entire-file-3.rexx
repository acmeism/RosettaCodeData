/*REXX program  writes  an  entire file  with a  single write  (a long text record).    */
oFID= 'OUTPUT.DAT'                               /*name of the output file to be used.  */
                                                 /* [↓]  50 bytes, including the fences.*/
$ = '<<<This is the text that is written to a file. >>>'
                                                 /* [↓]  COPIES  creates a 50k byte str.*/
call charout oFID, copies($,1000), 1             /*write the longish text to the file.  */
                                                 /* [↑]  the "1"  writes text ──► rec #1*/
                                                 /*stick a fork in it,  we're all done. */
