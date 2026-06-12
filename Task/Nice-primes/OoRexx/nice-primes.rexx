/* REXX */
n=1000
prime = .Array~new(n)~fill(.true)~~remove(1)
p.=0
Do i = 2 to n
  If prime[i] = .true Then Do
    Do j = i * i to n by i
      prime~remove(j)
      End
    p.i=1
    End
  End
z=0
ol=''
Do i=500 To 1000
  If p.i then Do
    dr=digroot(i)
    If p.dr Then Do
      ol=ol'  'i'('dr')'
      z=z+1
      If z//10=0 Then Do
        Say strip(ol)
        ol=''
        End
      End
    End
  End
Say strip(ol)
Say z 'nice primes in the range 500 to 1000'
Exit

digroot:
  Parse Arg s
  Do Until length(s)=1
    dr=0
    Do j=1 To length(s)
      dr=dr+substr(s,j,1)
      End
    s=dr
    End
  Return s
