/*REXX pgm reads a file, and displays the lines (records) of the file in reverse order. */
parse arg iFID .                                 /*obtain optional argument from the CL.*/
if iFID=='' | iFID=="," then iFID='REVERSEF.TXT' /*Not specified?  Then use the default.*/
call lineout iFID                                /*close file, good programming practice*/
                   do #=1  while lines(iFID)>0   /*read the file, one record at a time. */
                   @.#= linein(iFID)             /*assign contents of a record to array.*/
                   end   /*#*/
recs= # - 1                                      /*#  will be 1 more ('cause of DO loop)*/
                   do k=recs  by -1  for recs    /*process array (@.k) in reverse order.*/
                   say @.k                       /*display a record of the file ──► term*/
                   end   /*k*/
call lineout iFID                                /*close file, good programming practice*/
