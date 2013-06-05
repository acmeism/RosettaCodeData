/*REXX pgm to verify a file's size (by reading the lines) in CD & root. */
parse arg iFID .                       /*let user specify the file ID.  */
if iFID==''  then iFID="FILESIZ.DAT"   /*Not specified? Then use default*/
say 'size of'     iFID "=" filesize(iFID)       'bytes'   /*current dir.*/
say 'size of \..\'iFID "=" filesize('\..\'iFID) 'bytes'   /*   root dir.*/
exit                                   /*stick a fork in it, we're done.*/

/*──────────────────────────────────FILESIZE subroutine─────────────────*/
filesize:  parse arg f;  $=0;       do  while  lines(f)\==0
                                    $=$+length(charin(f,,1e6))
                                    end   /*while*/
return $
