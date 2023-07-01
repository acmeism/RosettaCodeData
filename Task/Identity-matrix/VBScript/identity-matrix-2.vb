n = 8

arr = Identity(n)

for i = 0 to n-1
    for j = 0 to n-1
        wscript.stdout.Write arr(i,j) & " "
    next
    wscript.stdout.writeline
next

Function Identity (size)
    Execute Replace("dim a(#,#):for i=0 to #:for j=0 to #:a(i,j)=0:next:a(i,i)=1:next","#",size-1)
    Identity = a
End Function
