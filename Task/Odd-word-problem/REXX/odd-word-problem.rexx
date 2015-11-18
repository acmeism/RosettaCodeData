/*REXX program solves the  odd word problem  by only using  byte input/output.*/
iFID_ = 'ODDWORD.IN'                   /*Note:  numeric suffix is added later.*/
oFID_ = 'ODDWORD.'                     /*  "       "       "    "   "     "   */

     do case=1  for 2;   #=0           /*#:  is the number of characters read.*/
     iFID=iFID_ || case                /*read   ODDWORD.IN1  or  ODDWORD.IN2  */
     oFID=oFID_ || case                /*write  ODDWORD.1    o r ODDWORD.2    */
     say;   say;    say '════════ reading file: '        iFID        "════════"

              do  until x==.           /* [↓]   perform DO loop for odd words.*/
                 do  until \isMix(x);  call readChar;   call writeChar;   end
              if x==.  then leave      /*is this end─of─sentence?  (full stop)*/
              call readLetters;             punctuation_location=#
                 do j=#-1  by -1;           call readChar  j
                 if \isMix(x)  then leave;  call writeChar
                 end   /*j*/           /* [↑]    perform for the "even" words.*/
              call readLetters;       call writeChar;    #=punctuation_location
              end      /*until x ···*/
     end   /*case*/                    /* [↑]  process both of the input files*/
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────one─liner subroutines─────────────────────*/
isMix:       return datatype(arg(1),'M')    /*return   1   if arg is a letter.*/
readLetters: do  until  \isMix(x);       call readChar;  end;          return
writeChar:   call charout ,x;            call charout oFID,x;          return
/*──────────────────────────────────readChar subroutine───────────────────────*/
readChar: if arg(1)==''  then do; x=charin(iFID); #=#+1; end  /*read next char*/
                         else     x=charin(iFID, arg(1))      /* "  specific "*/
          return
