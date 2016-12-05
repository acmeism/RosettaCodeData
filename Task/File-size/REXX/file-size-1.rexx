/*REXX program verifies a file's size (by reading all the lines)  in current dir & root.*/
parse arg iFID .                                 /*allow the user specify the  file ID. */
if iFID=='' | iFID==","  then iFID='FILESIZ.DAT' /*Not specified?  Then use the default.*/
say 'size of'     iFID   "="   fileSize(iFID)         'bytes'   /*the current directory.*/
say 'size of \..\'iFID   "="   fileSize('\..\'iFID)   'bytes'   /* "    root      "     */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
fileSize:  parse arg f;    $=0;       do  while  lines(f)\==0
                                      $=$+length(charin(f,,1e6))
                                      end   /*while*/
           return $
