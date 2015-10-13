/* REXX ************************************************************
* 26.11.2012 Walter Pachl
* added: show multiple occurrences
**********************************************************************/
old='2 3 5 7 11 13 17 19 cats 222 -100.2 +11 1.1 +7 7. 7 5 5',
    '3 2 0 4.4 2'
say 'old list='old
say 'words in the old list=' words(old)
new=''
found.=0
count.=0
Do While old<>''
  Parse Var old w old
  If found.w=0 Then Do
    new=new w
    found.w=1
    End
  count.w=count.w+1
  End
say 'new list='strip(new)
say 'words in the new list=' words(new)
Say 'Multiple occurrences:'
Say 'occ word'
Do While new<>''
  Parse Var new w new
  If count.w>1 Then
    Say right(count.w,3) w
  End
