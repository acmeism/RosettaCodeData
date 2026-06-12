/* REXX */
Call assert lcp("interspecies","interstellar","interstate"),"inters"
Call assert lcp("throne","throne"),"throne"
Call assert lcp("throne","dungeon"),""
Call assert lcp("cheese"),"cheese"
Call assert lcp("","")
Call assert lcp("prefix","suffix"),""
Call assert lcp("a","b","c",'aaa'),""
Call assert lcp("foo",'foobar'),"foo"
Call assert lcp("ab","","abc"),""
Exit

assert:
  If arg(1)==arg(2) Then tag='ok'
                    Else tag='??'
  Say tag 'lcp="'arg(1)'"'
  Say ''
  Return

lcp: Procedure
ol='test lcp('
Do i=1 To arg()
  ol=ol||""""arg(i)""""
  If i<arg() Then ol=ol','
             Else ol=ol')'
  End
Say ol
If arg()=1 Then
  Return arg(1)
s=lcp2(arg(1),arg(2))
Do i=3 To arg() While s<>''
  s=lcp2(s,arg(i))
  End
Return s

lcp2: Procedure
Do i=1 To min(length(arg(1)),length(arg(2)))
  If substr(arg(1),i,1)<>substr(arg(2),i,1) Then
    Leave
  End
Return left(arg(1),i-1)
