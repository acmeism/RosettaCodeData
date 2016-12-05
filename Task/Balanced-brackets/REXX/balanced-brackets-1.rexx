/*REXX program checks for balanced brackets     [  ]      ─── some fixed, others random.*/
parse arg seed .                                 /*obtain optional argument from the CL.*/
if datatype(seed,'W')  then call random ,,seed   /*if specified, then use as RANDOM seed*/
@.=0;          yesNo.0= right('not OK', 50)      /*for bad expressions, indent 50 spaces*/
               yesNo.1=           'OK'           /* [↓]  the 14 "fixed"  ][  expressions*/
q=                     ;          call checkBal  q;           say yesNo.result  '«null»'
q= '[][][][[]]'        ;          call checkBal  q;           say yesNo.result  q
q= '[][][][[]]]['      ;          call checkBal  q;           say yesNo.result  q
q= '['                 ;          call checkBal  q;           say yesNo.result  q
q= ']'                 ;          call checkBal  q;           say yesNo.result  q
q= '[]'                ;          call checkBal  q;           say yesNo.result  q
q= ']['                ;          call checkBal  q;           say yesNo.result  q
q= '][]['              ;          call checkBal  q;           say yesNo.result  q
q= '[[]]'              ;          call checkBal  q;           say yesNo.result  q
q= '[[[[[[[]]]]]]]'    ;          call checkBal  q;           say yesNo.result  q
q= '[[[[[]]]][]'       ;          call checkBal  q;           say yesNo.result  q
q= '[][]'              ;          call checkBal  q;           say yesNo.result  q
q= '[]][[]'            ;          call checkBal  q;           say yesNo.result  q
q= ']]][[[[]'          ;          call checkBal  q;           say yesNo.result  q
#=0                                                    /*# additional random expressions*/
          do j=1  until  #==26                         /*gen 26 unique bracket strings. */
          q=translate( rand( random(1,10) ), '][', 10) /*generate random bracket string.*/
          call checkBal q; if result==-1  then iterate /*skip if duplicated expression. */
          say yesNo.result  q                          /*display the result to console. */
          #=#+1                                        /*bump the  expression  counter. */
          end   /*j*/                            /* [↑]  generate 26 random "Q" strings.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
?:        ?=random(0,1);                                     return ? || \?   /*REXX BIF*/
rand:     $=copies(?()?(),arg(1));  _=random(2,length($));   return left($,_-1)substr($,_)
/*──────────────────────────────────────────────────────────────────────────────────────*/
checkBal: procedure expose @.; parse arg y       /*obtain the   "bracket"   expression. */
          if @.y  then return -1                 /*Done this expression before?  Skip it*/
          @.y=1                                  /*indicate expression was processed.   */
          !=0;         do j=1  for length(y);      _=substr(y,j,1)    /*get a character.*/
                       if _=='[' then      !=!+1                      /*bump the nest #.*/
                                 else do;  !=!-1;  if !<0  then return 0;   end
                       end   /*j*/
          return !==0                            /* [↑]  "!" is the nested  ][  counter.*/
