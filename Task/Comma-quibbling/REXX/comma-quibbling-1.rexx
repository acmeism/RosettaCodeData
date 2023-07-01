say quibbling('')
say quibbling('ABC')
say quibbling('ABC DEF')
say quibbling('ABC DEF G H')
exit

quibbling: procedure
    parse arg list
    Select
      When list='' Then result=''
      When words(list)=1 then result=word(list,1)
      Otherwise result=translate(strip(subword(list,1,words(list)-1)),',',' '),
        'and' word(list,words(list))
      End
    Return '{'result'}'
