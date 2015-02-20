say quibbling('')
say quibbling('ABC')
say quibbling('ABC DEF')
say quibbling('ABC DEF G H')
exit
quibbling:
  parse arg list
  If list='' Then result=''
  Else Do
    Do wi=1 By 1 while list<>''
      Parse Var list word.wi ' ' list
      End
    wn=wi-1
    result=word.1
    Do wi=2 To wn-1
      result=result', 'word.wi
      End
    If wn>1 Then
      result=result 'and' word.wn
    End
  Return '{'result'}'
