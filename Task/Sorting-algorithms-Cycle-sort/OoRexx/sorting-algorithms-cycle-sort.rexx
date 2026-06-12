/*REXX program demonstrates a cycle sort on a list of numbers**********
* 13.06.2014 Walter Pachl
* Modified from Rexx Version 2
* ooRexx allows to pass a stemmed variable by reference
* swapping variables uses a temporary instead of the parse.
**********************************************************************/
  a.1='George Washington  Virginia'
  a.2='John Adams  Massachusetts'
  a.3='Thomas Jefferson  Virginia'
  a.4='James Madison  Virginia'
  a.5='James Monroe  Virginia'
  n=5
  Call show 'Unsorted list: '
  w=sortcycle(a.,n)
  Say 'sorted'
  Call show 'Sorted list'
  Say ' '
  Say 'This took' w 'writes.'
  Exit

sortcycle: Procedure
  Use Arg a.,n
  writes=0
  Do c=1 For n
    x=a.c
    p=c
    x=a.c
    Do j=c+1 To n
      If a.j<x Then
        p=p+1
      End
    If p==c Then
      Iterate
    Do While x==a.p
      p=p+1
      End
    t=x
    x=a.p
    a.p=t
    writes=writes+1
    Do While p\==c
      p=c
      Do k=c+1 To n
        If a.k<x Then
          p=p+1
        End
      Do While x==a.p
        p=p+1
        End
      t=x
      x=a.p
      a.p=t
      writes=writes+1
      End
    End
  Return writes

show:
  Parse Arg hdr
  Say ' '
  Say hdr
  Do i=1 To n
    Say format(i,2) a.i
    End
  Return
