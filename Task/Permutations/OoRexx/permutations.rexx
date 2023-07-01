/* REXX Compute bunch permutations of things elements */
Parse Arg bunch things
If bunch='?' Then
  Call help
If bunch=='' Then bunch=3
If datatype(bunch)<>'NUM' Then Call help 'bunch ('bunch') must be numeric'
thing.=''
Select
  When things='' Then things=bunch
  When datatype(things)='NUM' Then Nop
  Otherwise Do
    data=things
    things=words(things)
    Do i=1 To things
      Parse Var data thing.i data
      End
    End
  End
If things<bunch Then Call help 'things ('things') must be >= bunch ('bunch')'

perms =0
Call time 'R'
Call permSets things, bunch
Say  perms  'Permutations'
Say time('E') 'seconds'
Exit

/*--------------------------------------------------------------------------------------*/
first_word: return word(Arg(1),1)
/*--------------------------------------------------------------------------------------*/
permSets: Procedure Expose perms thing.
  Parse Arg things,bunch
  aa.=''
  sep=''
  perm_elements='123456789ABCDEF'
  Do k=1 To things
    perm=first_word(first_word(substr(perm_elements,k,1) k))
    dd.k=perm
    End
  Call .permSet 1
  Return

.permSet: Procedure Expose dd. aa. things bunch perms thing.
  Parse Arg iteration
  If iteration>bunch  Then do
    perm= aa.1
    Do j=2 For bunch-1
      perm= perm aa.j
      End
    perms+=1
    If thing.1<>'' Then Do
      ol=''
      Do pi=1 To words(perm)
        z=word(perm,pi)
        If datatype(z)<>'NUM' Then
          z=9+pos(z,'ABCDEF')
        ol=ol thing.z
        End
      Say strip(ol)
      End
    Else
      Say perm
    End
  Else Do
    Do q=1 for things
      Do k=1 for iteration-1
        If aa.k==dd.q  Then
          iterate q
        End
      aa.iteration= dd.q
      Call .permSet iteration+1
      End
    End
  Return

help:
  Parse Arg msg
  If msg<>'' Then Do
    Say 'ERROR:' msg
    Say ''
    End
  Say 'rexx perm            -> Permutations of 1 2 3                 '
  Say 'rexx perm 2          -> Permutations of 1 2                   '
  Say 'rexx perm 2 4        -> Permutations of 1 2 3 4 in 2 positions'
  Say 'rexx perm 2 a b c d  -> Permutations of a b c d in 2 positions'
  Exit
