/* REXX implementation of the Verhoeff Algorithm  */
Call init                   -- fill the tables (data taken from Java Script)
Call check 236,1            -- compute check digit AND validate numbers
Call check 12345,1          -- "
Call check 123456789012,0   -- validate numbers
Exit

check:
  Parse Arg number,details
  numberx=number
  Say 'Check digit calculations for' number
  d=compute(number||0,details,1)
  Say 'The check digit for' numberx 'is' d
  Call check2 numberx||d,details
  Call check2 numberx||9,details
  Return

check2:
  Parse Arg number,details
  If details Then
    Say 'Validation calculations for' number
  d=compute(number,details,0)
  If d=0 Then
    Say 'The validation for' number' is correct.'
  Else
    Say 'The validation for' number' is incorrect.'
  Return

compute:
  Parse Arg number,details,show_inv
  Call details ''
  Call details ' i  ni  p[i, ni]  c'
  Call details '-------------------'
  c=0
  le=length(number)-1
  Do i=le To 0 By-1
    ni=substr(number,i+1,1)
    z=(le-i)//8
    pi=perm.z.ni
    c=mult.c.pi
    Call details right(le-i,2) right(ni,2) right(pi,7) right(c,5)
    End
  If show_inv Then
    Call details "inverse["c"] = "invt.c
  Return invt.c

details:
  If details Then
    Say arg(1)
  Return

init:
  Call mk_mult '[[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]',
               ' [1, 2, 3, 4, 0, 6, 7, 8, 9, 5]',
               ' [2, 3, 4, 0, 1, 7, 8, 9, 5, 6]',
               ' [3, 4, 0, 1, 2, 8, 9, 5, 6, 7]',
               ' [4, 0, 1, 2, 3, 9, 5, 6, 7, 8]',
               ' [5, 9, 8, 7, 6, 0, 4, 3, 2, 1]',
               ' [6, 5, 9, 8, 7, 1, 0, 4, 3, 2]',
               ' [7, 6, 5, 9, 8, 2, 1, 0, 4, 3]',
               ' [8, 7, 6, 5, 9, 3, 2, 1, 0, 4]',
               ' [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]]'

  Call mk_invt '[0, 4, 3, 2, 1, 5, 6, 7, 8, 9]'

  Call mk_perm '[[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]',
               ' [1, 5, 7, 6, 2, 8, 3, 0, 9, 4]',
               ' [5, 8, 0, 3, 7, 9, 6, 1, 4, 2]',
               ' [8, 9, 1, 6, 0, 4, 3, 5, 2, 7]',
               ' [9, 4, 5, 3, 1, 2, 6, 8, 7, 0]',
               ' [4, 2, 8, 6, 5, 7, 3, 9, 0, 1]',
               ' [2, 7, 9, 3, 8, 0, 6, 4, 1, 5]',
               ' [7, 0, 4, 6, 9, 1, 3, 2, 5, 8]]'
  Return

mk_mult:
  Parse Arg list
  list=translate(list,'   ','[],')
  Do i=0 to 9
    Do j=0 to 9
      Parse Var list mult.i.j list
      End
    End
  Return

mk_invt:
  Parse Arg list
  list=translate(list,'   ','[],')
  Do i=0 to 9
    Parse Var list invt.i list
    End
  Return

mk_perm:
  Parse Arg list
  list=translate(list,'   ','[],')
  Do i=0 to 9
    Do j=0 to 9
      Parse Var list perm.i.j list
      End
    End
  Return

show_mult:
  If details Then Say'show_mult'
  Do i=0 To 9
    l=''
    Do j=1 To 9
      l=l mult.i.j
      End
    Call details l
    End
  return
