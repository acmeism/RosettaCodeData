/*REXX program determines a file's size (by reading all the data)  on the default mDisk.*/
parse arg iFID                                   /*allow the user specify the  file ID. */
if iFID=='' | iFID==","  then iFID= 'INPUT TXT'  /*Not specified?  Then use the default.*/
say 'size of'     iFID     "="     fSize(iFID)     'bytes'       /*on the default mDisk.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
fSize: parse arg f;    $= 0;      do while lines(f)\==0;        $= $ + length( linein(f) )
                                  end   /*while*/
       return $
