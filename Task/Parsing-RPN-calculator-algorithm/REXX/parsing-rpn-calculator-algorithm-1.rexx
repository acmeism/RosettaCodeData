/* REXX ***************************************************************
* 09.11.2012 Walter Pachl  translates from PL/I
**********************************************************************/
fid='rpl.txt'
ex=linein(fid)
Say 'Input:' ex
/* ex=' 3 4 2 * 1 5 - 2 3 ^ ^ / +' */
Numeric Digits 15
expr=''
st.=0
Say 'Stack contents:'
do While ex<>''
  Parse Var ex ch +1 ex
  expr=expr||ch;
  if ch<>' ' then do
    select
      When pos(ch,'0123456789')>0 Then Do
        Call stack ch
        Iterate
        End
      when ch='+' Then do; operand=getstack(); st.sti = st.sti +  operand; end;
      when ch='-' Then do; operand=getstack(); st.sti = st.sti -  operand; end;
      when ch='*' Then do; operand=getstack(); st.sti = st.sti *  operand; end;
      when ch='/' Then do; operand=getstack(); st.sti = st.sti /  operand; end;
      when ch='^' Then do; operand=getstack(); st.sti = st.sti ** operand; end;
      end;
    call show_stack
    end
  end
Say 'The reverse polish expression = 'expr
Say 'The evaluated expression = 'st.1
Exit
stack: Procedure Expose st.
/* put the argument on top of the stack */
  z=st.0+1
  st.z=arg(1)
  st.0=z
  Return
getstack: Procedure Expose st. sti
/* remove and return the stack's top element */
  z=st.0
  stk=st.z
  st.0=st.0-1
  sti=st.0
  Return stk
show_stack: procedure Expose st.
/* show the stack's contents */
  ol=''
  do i=1 To st.0
    ol=ol format(st.i,5,10)
    End
  Say ol
  Return
