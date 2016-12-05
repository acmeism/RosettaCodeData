/*REXX program reads and writes a specified file  and  delete(s)  specified record(s).  */
parse arg  iFID   ','   N   ","   many   .       /*input FID, start of delete, how many.*/
if iFID=''  then call er  "no input fileID specified."                           /*oops.*/
if    N=''  then call er  "no start number specified."                           /*oops.*/
if many=''  then many=1                          /*Not specified?  Assume delete 1 line.*/
stop=N+many-1                                    /*calculate  high end  of delete range.*/
oFID=iFID'.$$$'                                  /*temp name (fileID) of the output file*/
#=0                                              /*the count (so far) of records written*/
      do j=1  while  lines(iFID)\==0             /*J  is the record# (line)  being read.*/
      @=linein(iFID)                             /*read a record (line) from input file.*/
      if j>=N & j<=stop  then iterate            /*if it's in the range, then ignore it.*/
      call lineout oFID,@;    #=#+1              /*write record (line);, bump write cnt.*/
      end   /*j*/                                /* [↑]  by ignoring it is to delete it.*/
j=j-1                                            /*adjust J (because of DO loop advance)*/
if j<stop  then say  "The number of lines in file is less than the range given."
$='"'                                            /*handle cases of blanks in the FID(s).*/
'ERASE'   $ || iFID || $                         /*erase the original file.             */
'RENAME'  $ || oFID || $      $ || iFID || $     /*rename "    new      "  to original. */
say 'file '    iFID    " had"    j    'record's(j)", it now has"     #    'record's(w)"."
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
er:   say;      say '***error***';        say;    say arg(1);         say;         exit 13
s:    if arg(1)==1  then return arg(3);   return word(arg(2) 's', 1)       /*pluralizer.*/
