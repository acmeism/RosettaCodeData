/* REXX */
x=3
list=x
Do i=1 By 1
  x=f(x)
  p=wordpos(x,list)
  If p>0 Then Do
    list=list x
    Say 'list ='list '...'
    Say 'Start index = ' (wordpos(x,list)-1) '(zero based)'
    Say 'Cycle length =' (words(list)-p)
    Say 'Cycle        =' subword(list,p,(words(list)-p))
    Leave
    End
  list=list x
  End
Exit
f: Return (arg(1)**2+1)//255
