/*REXX pgm to prompt user for: # (of secs); a name of a MP3 file to play*/

say '──────── Please enter a number of seconds to wait:'
parse pull waitTime .
                         /*add code to verify number is a valid number. */

say '──────── Please enter a name of an MP3 file to play:'
parse pull MP3FILE
                        /*add code to verify answer is a valid filename.*/

call sleep waitTime
MP3FILE'.MP3'
                                       /*stick a fork in it, we're done.*/
