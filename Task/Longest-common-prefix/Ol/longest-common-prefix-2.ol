Call assert lcp(.list~of("interspecies","interstellar","interstate")),"inters"
Call assert lcp(.list~of("throne","throne")),"throne"
Call assert lcp(.list~of("throne","dungeon")),""
Call assert lcp(.list~of("cheese")),"cheese"
Call assert lcp(.list~of("",""))
Call assert lcp(.list~of("prefix","suffix")),""
Call assert lcp(.list~of("a","b","c",'aaa')),""
Exit

assert:
  If arg(1)==arg(2) Then tag='ok'
                    Else tag='??'
  Say tag 'lcp="'arg(1)'"'
  Say ''
  Return

lcp:
Use Arg l
a=l~makearray()
s=l~makearray()~makestring((LINE),',')
say 'lcp('s')'
an=a~dimension(1)
If an=1 Then
  Return a[1]
s=lcp2(a[1],a[2])
Do i=3 To an While s<>''
  s=lcp2(s,a[i])
  End
Return s

lcp2:
Do i=1 To min(length(arg(1)),length(arg(2)))
  If substr(arg(1),i,1)<>substr(arg(2),i,1) Then
    Leave
  End
Return left(arg(1),i-1)
