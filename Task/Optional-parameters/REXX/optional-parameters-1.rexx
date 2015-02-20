sortStrings:  procedure expose @.      /*stemmed array is named:   @.   */
col=1;    reverse='NO';    order='LEXICOGRAPHIC'    /*set some defaults.*/
arg options
               do j=1  for words(options);     x=word(options,j)

                    select
                    when datatype(x, 'W')  then col=x/1
                    when pos('=', x)==0    then order=x
                    otherwise                   parse var x nam '=' value
                    end   /*select*/
               end        /*j*/
         /*╔═══════════════════════════════════════════════════════════╗
           ║ check for errors here:  COL isn't a positive integer ···, ║
           ║                         REVERSE value isn't  NO  or  YES, ║
           ║                         ORDER   value is recognized ···   ║
           ╚═══════════════════════════════════════════════════════════╝*/
       ... main body of string sort here ...
return                                 /*stick a fork in it, we're done.*/
