/*REXX program to check for balanced brackets   []                      */
@.=0
yesno.0 = left('',40) 'unbalanced'
yesno.1 = 'balanced'

q='[][][][[]]'         ; call checkBal q; say yesno.result q
q='[][][][[]]]['       ; call checkBal q; say yesno.result q
q='['                  ; call checkBal q; say yesno.result q
q=']'                  ; call checkBal q; say yesno.result q
q='[]'                 ; call checkBal q; say yesno.result q
q=']['                 ; call checkBal q; say yesno.result q
q='][]['               ; call checkBal q; say yesno.result q
q='[[]]'               ; call checkBal q; say yesno.result q
q='[[[[[[[]]]]]]]'     ; call checkBal q; say yesno.result q
q='[[[[[]]]][]'        ; call checkBal q; say yesno.result q
q='[][]'               ; call checkBal q; say yesno.result q
q='[]][[]'             ; call checkBal q; say yesno.result q
q=']]][[[[]'           ; call checkBal q; say yesno.result q

       do j=1 for 40
       q=translate(rand(random(1,8)),'[]',01)
       call checkBal q;   if result=='-1' then iterate
       say yesno.result q
       end
exit
/*âââââââââââââââââââââââââââââââââââPAND subroutineââââââââââââââââââââ*/
pand: p=random(0,1);    return p || \p
/*âââââââââââââââââââââââââââââââââââRAND subroutineââââââââââââââââââââ*/
rand: pp=pand();   pp=pand()pp;    pp=copies(pp,arg(1))
      i=random(2,length(pp));      pp=left(pp,i-1)substr(pp,i)
return pp
/*âââââââââââââââââââââââââââââââââââCHECKBAL subroutineââââââââââââââââ*/
checkBal: procedure expose @.;  arg y  /*check for balanced brackets [] */
nest=0;     if @.y then return '-1'    /*already done this expression ? */
@.y=1                                  /*indicate expression processed. */
        do j=1 for length(y);   _=substr(y,j,1)    /*pick off character.*/
        if _=='[' then     nest=nest+1
                  else do; nest=nest-1; if nest<0 then return 0; end
        end   /*j*/
return nest==0
