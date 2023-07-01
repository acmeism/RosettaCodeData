/* ooRexx *************************************************************
* 10.11.2012 Walter Pachl  translated from PL/I via REXX
**********************************************************************/
fid='rpl.txt'
ex=linein(fid)
Say 'Input:' ex
/* ex=' 3 4 2 * 1 5 - 2 3 ^ ^ / +' */
Numeric Digits 15
expr=''
st=.circularqueue~new(100)
Say 'Stack contents:'
do While ex<>''
  Parse Var ex ch +1 ex
  expr=expr||ch;
  if ch<>' ' then do
    If pos(ch,'0123456789')>0 Then     /* a digit goes onto stack    */
      st~push(ch)
    Else Do                            /* an operator                */
      op=st~pull                       /* get top element            */
      select                           /* and modify the (now) top el*/
        when ch='+' Then st~push(st~pull +  op)
        when ch='-' Then st~push(st~pull -  op)
        when ch='*' Then st~push(st~pull *  op)
        when ch='/' Then st~push(st~pull /  op)
        when ch='^' Then st~push(st~pull ** op)
        end;
      Say st~string(' ','L')           /* show stack in LIFO order   */
      end
    end
  end
Say 'The reverse polish expression = 'expr
Say 'The evaluated expression = 'st~pull
