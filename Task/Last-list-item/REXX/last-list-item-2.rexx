/* REXX */
List = '6 81 243 14 25 49 123 69 11'
Do Until words(list)=1
  Say 'List:' list
  a=getmin()
  b=getmin()
  Say 'Two smallest:' a '+' b '=' (a+b)
  list=list (a+b)
  End
Say 'Last item:' list
Exit

getmin: Procedure Expose list
/* Return the smallest element of list and remove it from list */
min=1e9
Do i=1 To words(list)
  If word(list,i)<min Then Do
    m=word(list,i)
    min=m
    j=i
    End
  End
list=subword(list,1,j-1) subword(list,j+1)
Return m
