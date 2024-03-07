/*REXX program reads a (bio-informational) FASTA file and displays the contents. */
Parse Arg ifid .                       /* iFID:  the input file to be read       */
If ifid=='' Then
  ifid='FASTA.IN'                      /* Not specified?  Then use the default   */
name=''                                /* the name of an output file (so far)    */
d=''                                   /* the value of the output file's         */
Do While lines(ifid)\==0               /* process the  FASTA  file contents      */
  x=strip(linein(ifid),'T')            /* read a line (a record) from the input  */
                                       /* and strip trailing blanks              */
  If left(x,1)=='>' Then Do            /* a new file id                          */
    Call out                           /* show output name and data              */
    name=substr(x,2)                   /* and get the new (or first) output name */
    d=''                               /* start with empty contents              */
    End
  Else                                 /* a line with data                       */
    d=d||x                             /* append it to output                    */
  End
Call out                               /* show output of last file used.         */
Exit

out:
If d\=='' Then                         /* if there ara data                      */
  Say name':' d                        /* show output name and data              */
Return
