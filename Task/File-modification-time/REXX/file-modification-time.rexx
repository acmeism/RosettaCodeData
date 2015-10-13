/*REXX program (Regina) to obtain/display a file's time of modification.      */
parse arg $ .                                     /*get the fileID from the CL*/
if $==''  then do;  say "***error*** no filename was specified.";  exit 13;  end
q=stream($, 'C', "QUERY TIMESTAMP")               /*get file's mod time info. */
if q==''  then q="specified file doesn't exist."  /*give an error indication. */
say 'For file: '  $                               /*display the file ID.      */
say 'timestamp of last modification: ' q          /*display modification time.*/
                                       /*stick a fork in it,  we're all done. */
