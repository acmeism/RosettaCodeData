/*REXX program checks for  balanced (square) brackets    [ ]                  */
@.=0;           yesNo.0=left('',40)  'unbalanced'   /*forty +1 leading blanks.*/
                yesNo.1=             'balanced'
q=                     ;         call checkBal q;         say yesNo.result  q
q= '[][][][[]]'        ;         call checkBal q;         say yesNo.result  q
q= '[][][][[]]]['      ;         call checkBal q;         say yesNo.result  q
q= '['                 ;         call checkBal q;         say yesNo.result  q
q= ']'                 ;         call checkBal q;         say yesNo.result  q
q= '[]'                ;         call checkBal q;         say yesNo.result  q
q= ']['                ;         call checkBal q;         say yesNo.result  q
q= '][]['              ;         call checkBal q;         say yesNo.result  q
q= '[[]]'              ;         call checkBal q;         say yesNo.result  q
q= '[[[[[[[]]]]]]]'    ;         call checkBal q;         say yesNo.result  q
q= '[[[[[]]]][]'       ;         call checkBal q;         say yesNo.result  q
q= '[][]'              ;         call checkBal q;         say yesNo.result  q
q= '[]][[]'            ;         call checkBal q;         say yesNo.result  q
q= ']]][[[[]'          ;         call checkBal q;         say yesNo.result  q

          do j=1  for 40
          q=translate(rand(random(1, 8)), '[]', 01)
          call checkBal q;  if result==-1  then iterate  /*skip if duplicated.*/
          say yesNo.result  q                            /*display the result.*/
          end   /*j*/                  /* [↑]  generate 40 random "Q" strings.*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
?:        ?=random(0,1);               return ? || \?
/*────────────────────────────────────────────────────────────────────────────*/
rand:     ??=copies(?()?(), arg(1));                    _=random(2, length(??))
          return left(??, _-1)substr(??, _)
/*────────────────────────────────────────────────────────────────────────────*/
checkBal: procedure expose @.; parse arg y  /*get the  "bracket"  expression. */
          if @.y  then return -1            /*already done this expression ?  */
          @.y=1                             /*indicate expression processed.  */
          !=0;         do j=1  for length(y);  _=substr(y,j,1)   /*get a char.*/
                       if _=='[' then      !=!+1                 /*bump nest #*/
                                 else do;  !=!-1;  if !<0  then return 0;   end
                       end   /*j*/
          return !==0                       /* [↑]  "!" is the nested counter.*/
