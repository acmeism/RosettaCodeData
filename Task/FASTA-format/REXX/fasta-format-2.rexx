/*REXX program reads a (bio-informational) FASTA file and displays the contents. */
Parse Arg iFID .                          /*iFID:  the input file to be read.    */
If iFID==''  Then iFID='FASTA2.IN'        /*Not specified?  Then use the default.*/
name=''                                   /*the name of an output file (so far). */
data=''
                                          /*the value of the output file's stuff.*/
Do While lines(iFID)\==0                  /*process the  FASTA  file contents.   */
  x=strip(linein(iFID),'T')               /*read a line (a record) from the file,*/
                                          /*--------- and strip trailing blanks. */
  Select
    When x=='' Then                       /* If the line is all blank,           */
      Nop                                 /* ignore it.                          */
    When left(x,1)==';' Then Do
      If name=='' Then name=substr(x,2)
      Say x
      End
    When left(x,1)=='>'  Then Do
      If data\=='' Then
        Say name':' data
      name=substr(x,2)
      data=''
      End
    Otherwise
      data=space(data||translate(x, ,'*'),0)
    End
  End
If data\=='' Then
  Say name':'  data                       /* [?]  show output of last file used. */
