/* REXX Compute permutations of things elements       */
/* implementing Heap's algorithm nicely shown in      */
/*   https://en.wikipedia.org/wiki/Heap%27s_algorithm */
/* Recursive Algorithm                                */
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
n=0
Do i=0 To things-1
  a.i=i
  End
Call generate things
Say time('R') 'seconds'
Exit

generate: Procedure Expose a. n e. things
  Parse Arg k
  If k=1 Then
    Call show
  Else Do
    Call generate k-1
    Do i=0 To k-2
      ka=k-1
      If k//2=0 Then
        Parse Value a.i a.ka With a.ka a.i
      Else
        Parse Value a.0 a.ka With a.ka a.0
      Call generate k-1
      End
    End
  Return

show: Procedure Expose a. n e. things
  n=n+1
  ol=''
  Do i=0 To things-1
    z=a.i
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
  Say 'rexx permx            -> Permutations of 1 2 3 4               '
  Say 'rexx permx 2          -> Permutations of 1 2                   '
  Say 'rexx permx a b c d    -> Permutations of a b c d in 2 positions'
  Exit
