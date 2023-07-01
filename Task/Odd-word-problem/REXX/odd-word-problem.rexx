/*REXX program solves the  odd word problem  by only using  (single) byte  input/output.*/
                           iFID_ = 'ODDWORD.IN'  /*Note:  numeric suffix is added later.*/
                           oFID_ = 'ODDWORD.'    /*  "       "       "    "   "     "   */
     do case=1  for 2;                #= 0       /*#:  is the number of characters read.*/
     iFID= iFID_  ||  case                       /*read   ODDWORD.IN1  or  ODDWORD.IN2  */
     oFID= oFID_  ||  case                       /*write  ODDWORD.1    or  ODDWORD.2    */
     say;   say;    say '════════ reading file: '        iFID        "════════"                /* ◄■■■■■■■■■ optional. */

         do  until x==.                          /* [↓]  perform until reaching a period*/
                do  until \datatype(x, 'M')      /* [↓]     "      "   punctuation found*/
                call rChar                       /*read  a single character.            */
                call wChar                       /*write "    "       "                 */
                end   /*until \data···*/         /* [↑]  read/write until punctuation.  */
         if x==.  then leave                     /*is this the end─of─sentence (period)?*/
         call readLetters;            punct= #   /*save the location of the punctuation.*/
                do j=#-1  by -1                  /*read some characters backwards.      */
                call rChar j                     /*read previous word (backwards).      */
                if \datatype(x, 'M')  then leave /*Found punctuation?   Then leave  J.  */
                call wChar                       /*write a character (which is a letter)*/
                end   /*j*/                      /* [↑]  perform for  "even"  words.    */
         call rLett                              /*read letters until punctuation found.*/
         call wChar;                  #= punct   /*write a char;  punctuation location. */
         end      /*until x==.*/
     end          /*case*/                       /* [↑]  process both of the input files*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
rLett: do  until  \datatype(x, 'M');         call rChar;             end;         return
wChar: call charout , x  /*console*/;        call charout oFID, x  /*file*/;      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
rChar: if arg()==0  then do; x= charin(iFID); #= #+1; end  /*read  next  char*/
                    else     x= charin(iFID, arg(1) );     /*  " specific  " */   return
