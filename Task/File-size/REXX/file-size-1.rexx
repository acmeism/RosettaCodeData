/*REXX program determines a file's size (by reading all the data) in current dir & root.*/
parse arg iFID .                                 /*allow the user specify the  file ID. */
if iFID=='' | iFID==","  then iFID='input.txt'   /*Not specified?  Then use the default.*/
say 'size of     'iFID   "="   fSize(iFID)         'bytes'      /*the current directory.*/
say 'size of \..\'iFID   "="   fSize('\..\'iFID)   'bytes'      /* "    root      "     */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
fSize: parse arg f;   $=0;   do while chars(f)\==0;    $ = $ + length( charin( f, , 1e4) )
                             end   /*while*/;          call lineout f      /*close file.*/
       return $
