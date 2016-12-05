/*REXX program obtains and displays a  file's  time of modification.                    */
parse arg $ .                                    /*obtain required argument from the CL.*/
if $==''  then do;  say "***error*** no filename was specified.";   exit 13;   end
q=stream($, 'C', "QUERY TIMESTAMP")              /*get file's modification time info.   */
if q==''  then q="specified file doesn't exist." /*set an error indication message.     */
say 'For file: '  $                              /*display the file ID information.     */
say 'timestamp of last modification: ' q         /*display the modification time info.  */
                                                 /*stick a fork in it,  we're all done. */
