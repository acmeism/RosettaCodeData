function nrls(byval s1)
  dim i,x
  if len(s1)<2 then nlrs=s :exit function
  s=lcase(replace(s1," ",""))
    redim a(127)
  dim ls:ls=len(s)
  start=1
  so=""
  ml=1
  a(asc(left(s,1)))=1
  for i=2 to ls+1
    if i>ls then
       rep=true
    else
      x=asc(mid(s,i,1))
      rep=a(x)<>0
    end if
    if a(x)<>0 then
      if (i-start)>ml then
           so=  mid(s,start,i-start)
           ml=(i-start)
      elseif   (i-start)=ml  then
           so=so & " " & mid(s,start,i-start)
      end if
      xx=a(x)
      for j= 96 to 122:
        if a(j)<=x then a(j)=0
      next
      start=xx+1
    end if
    a(x)=i
  next
  nrls=trim(so)
  erase a
end function

sub test (f)
  wscript.stdout.writeline "Original:   "&f
  wscript.stdout.writeline "Substrings: "&nrls(f)&vbcrlf
end sub

test "dabale arroz a la zorra el abad"
test "The quick brown fox jumps over the lazy dog"
test "ae"
test "aa"
test "abdefghij"
