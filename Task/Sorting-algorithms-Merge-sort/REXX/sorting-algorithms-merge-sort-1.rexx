/***********************************************************************
* After Paul van den Eertwegh reported that version 1 prodused
* incorrect results (which observation I verified)
* I decided to produce a nice program (instead of looking for the error)
* This version supports only words in the list.
* A version that can sort an array containing any string will follow
* A suggestion from Paul:
* By varying only one line
* if  word(a,1) > word(b,1) Then Do  -- numeric or mixed ascending
* if  word(a,1) >> word(b,1) Then Do -- string ascending
* if  word(a,1) < word(b,1) Then Do  -- numeric or mixed descending
* if  word(a,1) << word(b,1) Then Do -- string descending
* you may perform the usual sorts.
***********************************************************************/
Parse Arg list
If list='' Then
  unsortedList ='890 481 272 628 353 513 654 138 474 531'
Else
  unsortedList = list
sortedList = mergeSort(unsortedList)
say 'list  ='unsortedList
say 'sorted='space(sortedList)
Exit
mergesort: Procedure
  Parse Arg a
   if words(a)=1 Then return a
   mid=words(a)%2+1
   l1=subword(a,1,mid-1)
   l2=subword(a,mid)
      l1 = mergesort( l1 )
      l2 = mergesort( l2 )
      return merge( l1, l2 )
merge: Procedure
  Parse Arg a,b
  c=''
  Do while words(a)>0 & words(b)>0
    if  word(a,1) > word(b,1) Then Do
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
   return c
