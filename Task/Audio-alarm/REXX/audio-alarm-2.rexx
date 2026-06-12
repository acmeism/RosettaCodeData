/*REXX pgm to prompt user for: # (of secs); a name of a MP3 file to play*/

say '──────── Please enter a number of seconds to wait:'
parse pull waitTime .

say '──────── Please enter a name of an MP3 file to play:'
parse pull MP3FILE

call time 'Reset'                      /*reset the REXX (elapsed) timer.*/

   do  until time('E')  >waitTime      /*wait out the clock (in seconds)*/
   end

MP3FILE'.MP3'
                                       /*stick a fork in it, we're done.*/
