/*REXX program to read a specified file and delete specified record(s). */
parse arg iFID ',' at ',' many         /*input FID, del start, how many.*/
if iFID=''  then call er "no input fileID specified."
if   at=''  then call er "no start number specified."
if many=''  then many=1                /*Not specified?   Assume 1 line.*/
stop=at+many-1                         /*calculate high end of deletes. */
oFID=iFID'.out'                        /*the name of the output file.   */
w=0
      do j=1 while lines(iFID)\==0     /*J is the line number being read*/
      x=linein(iFID)                   /*read a line from the input file*/
      if j>=at & j<=stop then iterate  /*if in the range, then ignore it*/
      call lineout oFID,x;   w=w+1     /*write line, bump the write cnt.*/
      end
j=j-1
if j<stop then say "number of lines in file is less than the range given."
q='"'                                  /*handle cases of blanks in FID. */
'ERASE'   q || ifid || q
'RENAME'  q || ofid || q     q || ifid || q
say 'file ' iFID " had" j 'record's(j)", it now has" w 'record's(w)"."
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ER subroutine───────────────────────*/
er: say; say '***error!***; say; say arg(1); say; exit 13
/*──────────────────────────────────S subroutine────────────────────────*/
s: if arg(1)==1 then return arg(3);return word(arg(2) 's',1)  /*plurals.*/
