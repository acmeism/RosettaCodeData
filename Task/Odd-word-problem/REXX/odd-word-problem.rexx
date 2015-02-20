/*REXX program solves the  odd word  problem  by just using  byte I/O.  */
iFID_ = 'ODDWORD.IN'                   /*numeric suffix is added later. */
oFID_ = 'ODDWORD.'                     /*   "       "    "   "     "    */

     do case=1  for 2;   #=0           /*#:   number of characters read.*/
     iFID=ifid_ || case                /*read ODDWORD.IN1 or ODDWORD.IN2*/
     oFID=ofid_ || case                /*write ODDWORD.1  or ODDWORD.2  */
     say;  say;   say '──────── reading file: '      iFID      "────────"

              do  until x=='.'         /* [↓]    perform for odd words. */

                 do      until \datatype(x,'M')
                 call readChar;          call writeChar
                 end   /*until \datatype···*/

              if x=='.'  then leave    /*end─of─sentence?   (full stop) */
              call readLetters;   punctuation_loc=#
                                       /* [↓]    perform for even words.*/
                 do j=#-1  by -1;                        call readChar j
                 if \datatype(x,'M')  then leave;        call writeChar
                 end   /*j*/

              call readLetters;       call writeChar;    #=punctuation_loc
              end      /*until x ···*/
     end   /*case*/                    /* [↑]  process both input files.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────one─liner subroutines───────────────*/
readLetters: do  until  \datatype(x,'M');   call readChar;  end;    return
writeChar:   call charout ,x;               call charout oFID,x;    return
serr:        say; say '***error!***' arg(1);  say;  exit 13   /*oops─ay.*/
/*──────────────────────────────────readChar subroutine─────────────────*/
readChar: if lines(iFID)==0  then call serr 'EOF reached.'    /*no file.*/
if arg(1)==''  then do; x=charin(ifid); #=#+1; end  /*read the next char*/
               else     x=charin(ifid, arg(1))      /*  "  specific   " */
return
