/*REXX pgm to verify a file's size */
parse arg iFID .                       /*let user specify the file ID.  */
if iFID==''  then iFID="FILESIZ.DAT"   /*Not specified? Then use default*/
say 'size of' iFID':'
Say chars(ifid) '(CR LF included)'
Call lineout ifid /* close the file */
say filesize(ifid) '(net data)'
Call lineout ifid
exit

filesize:  parse arg f;
  sz=0;
  Do while lines(f)\==0
    sz=sz+length(linein(f))
    End
  return sz
