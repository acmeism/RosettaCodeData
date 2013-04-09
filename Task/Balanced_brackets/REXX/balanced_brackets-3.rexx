/*REXX program to check for balanced brackets    [ ]                    */
count=0
nested=0
yesno.0 = left('',40) 'unbalanced'
yesno.1 = 'balanced'
q=''                   ; call checkBal q; say yesno.result q
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
call teller
count=0
nested=0
          do j=1                       /*generate lots of permutations. */
          q=translate(strip(x2b(d2x(j)),'L',0),"][",01)  /*convert──►[].*/
          if countstr(']',q)\==countstr('[',q) then iterate /*compliant?*/
          call checkBal q
          if length(q)>20 then leave   /*done all 20-char possibilities?*/
          end
/*───────────────────────────────────TELLER subroutine──────────────────*/
teller: say
say count " expressions were checked, " nested ' were balanced, ',
    count-nested " were unbalanced."
return
/*───────────────────────────────────CHECKBAL subroutine────────────────*/
checkBal:  procedure expose nested count;   parse arg y;   count=count+1
nest=0
        do j=1 for length(y);   _=substr(y,j,1)    /*pick off character.*/
          select
          when _=='[' then      nest=nest+1        /*opening bracket ...*/
          when _==']' then do;  nest=nest-1;  if nest<0 then leave;  end
          otherwise  nop                           /*ignore any chaff.  */
          end   /*select*/
        end     /*j*/
nested=nested + (nest==0)
return           nest==0
/* ┌──────────────────────────────────────────────────────────────────┐
   │ COUNTSTR    counts the number of occurances of a string (or char)│
   │ within another string (haystack) without overlap.  If either arg │
   │ is null,  0 (zero)  is returned.     To make the subroutine case │
   │ insensative, change the   PARSE ARG ...   statement to   ARG ... │
   │ Example:  yyy = 'The quick brown fox jumped over the lazy dog.'  │
   │           zz  = countstr('o',yyy)      /*ZZ will be set to 4 */  │
   │ Note that   COUNTSTR   is also a built-in function of the newer  │
   │ REXX interpreters,  and the result should be identical.   Checks │
   │ could be added to validate if  2  or  3  arguments are passed.   │
   └──────────────────────────────────────────────────────────────────┘ */
countstr: procedure;   parse arg n,h,s;   if s=='' then s=1;   w=length(n)
          do r=0 until _==0;   _=pos(n,h,s);   s=_+w;   end;      return r
