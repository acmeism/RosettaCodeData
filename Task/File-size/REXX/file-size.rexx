/*REXX pgm to verify a file's size (by reading the lines) in CD & root. */
parse arg iFID .                       /*let user specify the file ID.  */
if iFID==''  then iFID='FILESIZ.DAT'   /*Not specified? Then use default*/
say 'size of'     iFID '=' filesize(iFID)           /*current directory.*/
say 'size of \..\'iFID '=' filesize('\..\'iFID)     /*   root directory.*/
exit                                   /*stick a fork in it, we're done.*/

/*──────────────────────────────────FILESIZE subroutine─────────────────*/
filesize:  parse arg f
                                    do r=1  while lines(f)\==0
                                    call linein f
                                    end   /*r*/
return r-1
