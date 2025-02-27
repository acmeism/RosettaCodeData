/***********************************************************************
* Translating blanks in the array's elements lets me use Version 1
***********************************************************************/
Call Init
unsortedList=''
Do i=1 To arr.0
  If pos('00'x,arr.i)>0 Then Do
    'Sorry, array elements must not contain ''00''x characters'
    Exit
    End
  unsortedList=unsortedList translate(arr.i,'00'x,' ')
  End
say 'Array :'
Call show
sortedList = mergeSort(unsortedList)
Do i=1 To arr.0
  arr.i=translate(word(sortedList,i),' ','00'x)
  End
Say ''
Say 'Sorted:'
Call show
Exit
show:
  Do i=1 To arr.0
    Say 'arr.'i'='arr.i
    End
  Return
mergesort: Procedure
  Parse Arg a
  If words(a)=1 Then Return a
  mid=words(a)%2+1
  l1=subword(a,1,mid-1)
  l2=subword(a,mid)
  l1 = mergesort( l1 )
  l2 = mergesort( l2 )
  Return merge( l1, l2 )
merge: Procedure
  Parse Arg a,b
  c=''
  Do while words(a)>0 & words(b)>0
    If  word(a,1) > word(b,1) Then Do
       c=c word(b,1)
       b=subword(b,2)
       End
    Else Do
       c=c word(a,1)
       a=subword(a,2)
       End
   end
   c=c a
   c=c b
   Return c

init:
  arr.=0
  Call store '---The seven deadly sins---'
  Call store '==========================='
  Call store 'pride'
  Call store 'avarice'
  Call store 'wrath'
  Call store 'envy'
  Call store 'gluttony'
  Call store 'sloth'
  Call store 'lust'
  Return
store:
  z=arr.0+1
  arr.z=arg(1)
  arr.0=z
  Return
