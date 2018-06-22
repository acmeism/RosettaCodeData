/*REXX program reads a file  and  displays  the  longest [widest]  record(s) [line(s)]. */
signal on notReady                               /*when E-O-F is reached,  jump/branch. */
iFID= 'LONGEST.TXT'                              /*the default file identifier for input*/
parse arg fid .                                  /*obtain optional argument from the CL.*/
    do #=1  to length(fid);          iFID=fid    /*Specified?   Then use what's given.  */
    end   /*#*/
!=                                               /*the maximum width  (so far).         */
    do forever;    _=linein(iFID);   ?=_         /*read a line from the input file.     */
    t=0                                          /*don't do the initialization next time*/
        do #=t  for t;    !=?;       ?=;        $=. || _;       end  /*just do 1st time.*/
        do #=length(!' ')  to length(?) for 1;  $=;             end  /*found widest rec.*/
        do #=length(!)     to length(?) for 1;  $=$'a0d'x || _; end  /*append it to  $. */
                                                 /* [↑]  variable  #  isn't really used.*/
    !=left(.,  max( length(!), length(?) ) )     /*!:  is the max length record, so far.*/
    end   /*forever*/
                                                 /* [↓]  comes here when file gets E─O─F*/
notReady:   do j=length(!)  to length(!)  for length(!)    /*handle the case of no input*/
            say substr($, 2)                     /*display (all) the longest records.   */
            end   /*j*/                          /*stick a fork in it,  we're all done. */
