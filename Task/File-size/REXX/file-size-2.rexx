/*REXX pgm to verify a file's size (by reading the lines) on default MD.*/
parse arg iFID                         /*let user specify the file ID.  */
if iFID=''  then iFID="FILESIZ DAT A"  /*Not specified? Then use default*/
say 'size of'     iFID "=" filesize(iFID) 'bytes'   /*on the default MD.*/
exit                                   /*stick a fork in it, we're done.*/

/*──────────────────────────────────FILESIZE subroutine─────────────────*/
filesize:  parse arg f;  $=0;       do  while  lines(f)\==0
                                    $=$+length(linein(f))
                                    end   /*while*/
return $
