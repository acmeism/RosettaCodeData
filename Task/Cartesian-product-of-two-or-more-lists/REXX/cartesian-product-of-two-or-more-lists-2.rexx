/* REXX computes the Cartesian Product of up to 4 sets */
Call cart '{1, 2} x {3, 4}'
Call cart '{3, 4} x {1, 2}'
Call cart '{1, 2} x {}'
Call cart '{} x {1, 2}'
Call cart '{1776, 1789} x {7, 12} x {4, 14, 23} x {0, 1}'
Call cart '{1, 2, 3} x {30} x {500, 100}'
Call cart '{1, 2, 3} x {} x {500, 100}'
Exit

cart:
  Parse Arg sl
  Say sl
  Do i=1 By 1 while pos('{',sl)>0
    Parse Var sl '{' list '}' sl
    Do j=1 By 1 While list<>''
      Parse Var list e.i.j . ',' list
      End
    n.i=j-1
    If n.i=0 Then Do /* an empty set */
      Say '{}'
      Say ''
      Return
      End
    End
  n=i-1
  ct2.=0
  Do i=1 To n.1
    Do j=1 To n.2
      z=ct2.0+1
      ct2.z=e.1.i e.2.j
      ct2.0=z
      End
    End
  If n<3 Then
    Return output(2)
  ct3.=0
  Do i=1 To ct2.0
    Do k=1 To n.3
      z=ct3.0+1
      ct3.z=ct2.i e.3.k
      ct3.0=z
      End
    End
  If n<4 Then
    Return output(3)
  ct4.=0
  Do i=1 To ct3.0
    Do l=1 To n.4
      z=ct4.0+1
      ct4.z=ct3.i e.4.l
      ct4.0=z
      End
    End
  Return output(4)

output:
  Parse Arg u
  Do v=1 To value('ct'u'.0')
    res='{'translate(value('ct'u'.'v),',',' ')'}'
    Say res
    End
  Say ' '
  Return 0
