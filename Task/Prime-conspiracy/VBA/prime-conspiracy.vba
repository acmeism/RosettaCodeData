Option Explicit

Sub Main()
Dim Dict As Object, L() As Long
Dim t As Single

   Init Dict
   L = ListPrimes(100000000)
t = Timer
   PrimeConspiracy L, Dict, 1000000
Debug.Print "----------------------------"
Debug.Print "Execution time : " & Format(Timer - t, "0.000s.")
Debug.Print ""
   Init Dict
t = Timer
   PrimeConspiracy L, Dict, 5000000
Debug.Print "----------------------------"
Debug.Print "Execution time : " & Format(Timer - t, "0.000s.")
End Sub

Private Function ListPrimes(MAX As Long) As Long()
'http://rosettacode.org/wiki/Extensible_prime_generator#VBA
Dim t() As Boolean, L() As Long, c As Long, s As Long, i As Long, j As Long
    ReDim t(2 To MAX)
    ReDim L(MAX \ 2)
    s = Sqr(MAX)
    For i = 3 To s Step 2
        If t(i) = False Then
            For j = i * i To MAX Step i
                t(j) = True
            Next
        End If
    Next i
    L(0) = 2
    For i = 3 To MAX Step 2
        If t(i) = False Then
            c = c + 1
            L(c) = i
        End If
    Next i
    ReDim Preserve L(c)
    ListPrimes = L
End Function

Private Sub Init(d As Object)
   Set d = CreateObject("Scripting.Dictionary")
   d("1 to 1") = 0
   d("1 to 3") = 0
   d("1 to 7") = 0
   d("1 to 9") = 0
   d("2 to 3") = 0
   d("3 to 1") = 0
   d("3 to 3") = 0
   d("3 to 5") = 0
   d("3 to 7") = 0
   d("3 to 9") = 0
   d("5 to 7") = 0
   d("7 to 1") = 0
   d("7 to 3") = 0
   d("7 to 7") = 0
   d("7 to 9") = 0
   d("9 to 1") = 0
   d("9 to 3") = 0
   d("9 to 7") = 0
   d("9 to 9") = 0
End Sub

Private Sub PrimeConspiracy(Primes() As Long, Dict As Object, Nb)
Dim n As Long, temp As String, r, s, K
   For n = LBound(Primes) To Nb
      r = CStr((Primes(n)))
      s = CStr((Primes(n + 1)))
      temp = Right(r, 1) & " to " & Right(s, 1)
      If Dict.Exists(temp) Then Dict(temp) = Dict(temp) + 1
   Next
   Debug.Print Nb & " primes, last prime considered: " & Primes(Nb)
   Debug.Print "Transition  Count     Frequency"
   Debug.Print "==========  =======   ========="
   For Each K In Dict.Keys
      Debug.Print K & "      " & Right("      " & Dict(K), 6) & "    " & Dict(K) / Nb * 100 & "%"
   Next
End Sub
