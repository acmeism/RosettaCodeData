! Loops Increment loop index within loop body - 17/07/2018
      integer*8 n
      imax=42
      i=0; n=42
      Do While(i<imax)
        If (isprime(n)==1) Then
          i=i+1
          Write (*,'(I2,1X,I20)') i,n
          n=n+n-1
        EndIf
        n=n+1
      EndDo
      End

      Function isprime(n)
        integer*8 n,i
        If (n==2 .OR. n==3) Then
          isprime=1
          return
        ElseIf (Mod(n,2)==0 .OR. Mod(n,3)==0) Then
          isprime=0
          return
        Else
          i=5
          Do While(i*i<=n)
            If (Mod(n,i)==0 .OR. Mod(n,i+2)==0) Then
              isprime=0
              return
            EndIf
            i=i+6
          EndDo
          isprime=1
          return
        EndIf
      EndFunction
