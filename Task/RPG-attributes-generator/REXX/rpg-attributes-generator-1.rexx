/* REXX
Generates 4 random, whole values between 1 and 6.
Saves the sum of the 3 largest values.
Generates a total of 6 values this way.
Displays the total, and all 6 values once finished.
*/
Do try=1 By 1
  ge15=0
  sum=0
  ol=''
  Do i=1 To 6
    rl=''
    Do j=1 To 4
      rl=rl (random(5)+1)
      End
    rl=wordsort(rl)
    rsum.i=maxsum()
    If rsum.i>=15 Then ge15=ge15+1
    sum=sum+rsum.i
    ol=ol right(rsum.i,2)
    End
  Say ol '->' ge15 sum
  If ge15>=2 & sum>=75 Then Leave
  End
Say try 'iterations'
Say ol '=>' sum
Exit

maxsum: procedure Expose rl
/**********************************************************************
* Comute the sum of the 3 largest values
**********************************************************************/
  m=0
  Do i=2 To 4
    m=m+word(rl,i)
    End
  Return m

wordsort: Procedure
/**********************************************************************
* Sort the list of words supplied as argument. Return the sorted list
**********************************************************************/
  Parse Arg wl
  wa.=''
  wa.0=0
  Do While wl<>''
    Parse Var wl w wl
    Do i=1 To wa.0
      If wa.i>w Then Leave
      End
    If i<=wa.0 Then Do
      Do j=wa.0 To i By -1
        ii=j+1
        wa.ii=wa.j
        End
      End
    wa.i=w
    wa.0=wa.0+1
    End
  swl=''
  Do i=1 To wa.0
    swl=swl wa.i
    End
  Return strip(swl)
