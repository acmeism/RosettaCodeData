/* REXX Compute permutations of things elements       */
/* implementing Heap's algorithm nicely shown in      */
/*   https://en.wikipedia.org/wiki/Heap%27s_algorithm */
/* Iterative Algorithm                                */
Parse Arg things
e.=''
Select
  When things='?' Then
    Call help
  When things='' Then
    things=4
  When words(things)>1 Then Do
    elements=things
    things=words(things)
    Do i=0 By 1 While elements<>''
      Parse Var elements e.i elements
      End
    End
  Otherwise
    If datatype(things)<>'NUM' Then Call help 'bunch ('bunch') must be numeric'
  End
Do i=0 To things-1
  a.i=i
  End
Call time 'R'
Call generate things
Say time('E') 'seconds'
Exit

generate:
  Parse Arg n
  Call show
  c.=0
  i=0
  Do While i<n
    If c.i<i Then Do
      if i//2=0 Then
        Parse Value a.0 a.i With a.i a.0
      Else Do
        z=c.i
        Parse Value a.z a.i With a.i a.z
        End
      Call show
      c.i=c.i+1
      i=0
      End
    Else Do
      c.i=0
      i=i+1
      End
    End
  Return

show:
  ol=''
  Do j=0 To n-1
    z=a.j
    If e.0<>'' Then
      ol=ol e.z
    Else
      ol=ol z
    End
  Say strip(ol)
  Return
Exit

help:
  Parse Arg msg
  If msg<>'' Then Do
    Say 'ERROR:' msg
    Say ''
    End
  Say 'rexx permxi            -> Permutations of 1 2 3 4               '
  Say 'rexx permxi 2          -> Permutations of 1 2                   '
  Say 'rexx permxi a b c d    -> Permutations of a b c d in 2 positions'
  Exit
