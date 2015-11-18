/* REXX ***************************************************************
* Forward differences
* 18.08.2012 Walter Pachl derived from PL/I
**********************************************************************/
Do n=-1 To 11
  Call differences '90 47 58 29 22 32 55 5 55 73',n
  End
Exit

differences: Procedure
  Parse Arg a,n
  m=words(a)
  Select
    When n<0 Then Say 'n is negative:' n '<' 0
    When n>m Then Say 'n is too large:' n '>' m
    Otherwise Do
      Do i=1 By 1 while a<>''
        Parse Var a a.i a
        End
      Do i = 1 to n;
        t = a.i;
        Do j = i+1 to m;
          u = a.j
          a.j = a.j-t;
          t = u;
          end;
        end;
      ol=''
      Do k=n+1 to m
        ol=ol a.k
        End
      Say n ol
      End
    End
  Return
