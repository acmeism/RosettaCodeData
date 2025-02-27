/******************************************************************
* Translated from REXX Version 1a
* with a little help from a friend:-)
******************************************************************/
Call Init
Call show 'Array:'
arr=mergeSort(arr)
Say ''
Call show 'Sorted:'
Exit
mergesort: Procedure
  Use Arg a
  If a~items=1 Then Return a
  mid=a~items%2+1
  l1=a~section(1,mid-1)
  l2=a~section(mid)
  l1 = mergesort( l1 )
  l2 = mergesort( l2 )
  Return merge( l1, l2 )

merge: Procedure
  Use Arg a,b
  c=.array~new
  Do while a~items>0 & b~items>0
    if  a[1] > b[1] Then Do
       c~append(b[1])
       b=b~section(2)
       End
    Else Do
       c~append(a[1])
       a=a~section(2)
       End
   end
   c~appendAll(a)
   c~appendAll(b)
   Return c

init:
  arr=.array~new
  arr~append('---The seven deadly sins---')
  arr~append('===========================')
  arr~append('pride')
  arr~append('avarice')
  arr~append('wrath')
  arr~append('envy')
  arr~append('gluttony')
  arr~append('sloth')
  arr~append('lust')
  Return

show:
  Say arg(1)
  Do elem over arr
    Say elem
    End
  Return
