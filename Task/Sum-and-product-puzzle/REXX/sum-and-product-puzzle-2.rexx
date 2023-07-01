Call time 'R'
Do s=2 To 100
  a=satisfies_statement3(s)
  If a>0 Then Do
    p=a*(s-a)
    Say a'/'||(s-a) 's='s 'p='p
    End
  End
Say 'Elapsed time:' time('E') 'seconds'
Exit

satisfies_statement1: Procedure
  Parse Arg s
  Do a=2 To s/2
    If is_prime(a) & is_prime(s-a) Then
      Return 0
    End
  Return 1

satisfies_statement2: Procedure
  Parse Arg p
  winner=0
  Do i=2 By 1 While i**2<p
    If p//i=0 Then Do
      j=p%i
      If 2<=j & j<=99 Then Do
        if satisfies_statement1(i+j) Then Do
          if winner Then
            Return 0
          winner=1
          End
        End
      End
    End
  Return winner

satisfies_statement3: Procedure
  Parse Arg s
  winner=0
  If satisfies_statement1(s)=0 Then
    Return 0
  Do a=2 To s/2
    b=s-a
    If satisfies_statement2(a*b) Then Do
      If winner>0 Then
        Return 0
      winner=a
      End
    End
  Return winner

is_prime: Procedure
  call Trace 'O'
  Parse Arg x
  If x<=3 Then Return 1
  i=2
  Do i=2 By 1 While i**2<=x
    If datatype(x/i,'W') Then Return 0
    End
  Return 1
