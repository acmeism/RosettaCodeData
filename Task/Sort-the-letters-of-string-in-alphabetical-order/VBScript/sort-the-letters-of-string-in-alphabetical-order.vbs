sub bubble(arr)
  n = UBound(arr)
  Do
    nn = -1
    For j = 0 to n - 1
        If arr(j) > arr(j + 1) Then
            temp= arr(j):arr(j)=arr(j+1):arr(j+1)=temp
           nn = j
        End If
    Next
    n = nn
  Loop Until nn = -1
end sub


s="The quick brown fox jumps over the lazy dog, apparently"
redim a(len(s)-1)
for i=1 to len(s)
   a(i-1)=mid(s,i,1)
next
bubble a
s1=join(a,"")
wscript.echo s1
