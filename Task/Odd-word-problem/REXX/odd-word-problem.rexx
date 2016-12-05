/*REXX program  solves the  odd word  problem  by  only using  byte  input/output.      */
iFID_ = 'ODDWORD.IN'                             /*Note:  numeric suffix is added later.*/
oFID_ = 'ODDWORD.'                               /*  "       "       "    "   "     "   */

     do case=1  for 2;   #=0                     /*#:  is the number of characters read.*/
     iFID=iFID_ || case                          /*read   ODDWORD.IN1  or  ODDWORD.IN2  */
     oFID=oFID_ || case                          /*write  ODDWORD.1    o r ODDWORD.2    */
     say;   say;    say '════════ reading file: '        iFID        "════════"                /* ◄■■■■■■■■■ optional. */

         do  until x==.                               /* [↓]  perform for  "odd"  words.*/
            do  until \isMix(x);                      /* [↓]  perform until punct found.*/
            call readChar;    call writeChar          /*read and write a letter.        */
            end   /*until ¬isMix(x)*/                 /* [↑]  keep reading    "     "   */
         if x==.  then leave                          /*is this the  end─of─sentence ?  */
         call readLetters;    punct=#                 /*save the location of punctuation*/
            do j=#-1  by -1;  call readChar j         /*read previous word (backwards). */
            if \isMix(x)  then leave;  call writeChar /*Found punctuation?  Then leave. */
            end   /*j*/                               /* [↑]  perform for  "even" words.*/
         call readLetters;   call writeChar;  #=punct /*read/write letters; new location*/
         end      /*until x==.*/
     end          /*case*/                            /* [↑]  process both input files. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isMix:       return datatype( arg(1), 'M')       /*return   1   if argument is a letter.*/
readLetters: do  until  \isMix(x);          call readChar;         end;             return
writeChar:   call charout , x;              call charout oFID, x;                   return
/*──────────────────────────────────────────────────────────────────────────────────────*/
readChar:    if arg(1)==''  then do;  x=charin(iFID);  #=#+1;  end  /*read the next char*/
                            else      x=charin(iFID, arg(1))        /*  "  specific   " */
             return
