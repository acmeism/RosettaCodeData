a=.array~of( -5, 26, 0, 2, 11, 19, 90)
x=21
n=0
do i=1 To a~items
  Do j=i+1 To a~items
    If a[i]+a[j]=x Then Do
      Say '['||i-1||','||j-1||']'
      n=n+1
      End
    End
  End
If n=0 Then
  Say '[] - no items found'
