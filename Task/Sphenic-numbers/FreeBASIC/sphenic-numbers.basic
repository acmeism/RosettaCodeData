Dim Shared Factors(3) As Uinteger

Function Sphenic(N As Uinteger) As Boolean
    Dim As Uinteger C, F, L, Q
    L = Sqr(N)
    C = 0
    F = 2
    Do
        Q = N / F
        If N Mod F = 0 Then
            Factors(C) = F
            C += 1
            If C > 3 Then Return False
            N = Q
            If N Mod F = 0 Then Return False
            If F > N Then Exit Do
        Else
            F += 1
            If F > L Then
                Factors(C) = N
                C += 1
                Exit Do
            End If
        End If
    Loop
    Return Iif(C = 3, True, False)
End Function

Dim As Double t0 = Timer
Dim As Uinteger C, N, I
C = 0
N = 2 * 3 * 5
Print "Sphenic numbers less than 1,000:"
Do
    If Sphenic(N) Then
        C += 1
        If N < 1000 Then
            Print Using "####"; N;
            If C Mod 15 = 0 Then Print
        End If
        If C = 200000 Then
            Print "The 200,000th sphenic number is "; N; " = ";
            For I = 0 To 2
                Print Factors(I);
                If I < 2 Then Print " * ";
            Next I
            Print
        End If
    End If
    N += 1
    If N >= 1e6 Then Exit Do
Loop
Print "There are "; C; " sphenic numbers less than 1,000,000"

C = 0
N = 2 * 3 * 5
Print !"\nSphenic triplets less than 10,000:"
Do
    If Sphenic(N) Andalso Sphenic(N+1) Andalso Sphenic(N+2) Then
        C += 1
        If N < 10000 Then
            Print "[" & N & ", " & N+1 & ", " & N+2 & "]";
            If C Mod 3 = 0 Then Print Else Print ", ";
        End If
        If C = 5000 Then
            Print "The 5000th sphenic triplet is [" & N & ", " & N+1 & ", " & N+2 & "]"
        End If
    End If
    N += 1
    If N+2 >= 1e6 Then Exit Do
Loop
Print "There are "; C; " sphenic triplets less than 1,000,000"

Print Using "##.##sec."; Timer - t0

Sleep
