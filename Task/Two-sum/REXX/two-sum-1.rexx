/* REXX */
list='-5 26 0 2 11 19 90'
Do i=0 By 1 Until list=''
  Parse Var list a.i list
  End
n=i
x=21
z=0
do i=0 To n
  Do j=i+1 To n
    s=a.i+a.j
    If s=x Then Do
      z=z+1
      Say '['i','j']' a.i a.j s
      End
    End
  End
If z=0 Then
  Say '[] - no items found'
Else
  Say z 'solutions found'
