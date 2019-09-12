'RosettaCode Hamming numbers
'This is a well known hard problem in number theory:
'counting the number of lattice points in a
'n-dimensional tetrahedron, here n=3.
Public a As Double, b As Double, c As Double, d As Double
Public p As Double, q As Double, r As Double
Public cnt() As Integer 'stores the number of lattice points indexed on the exponents of 3 and 5
Public hn(2) As Integer 'stores the exponents of 2, 3 and 5
Public Declare Function GetTickCount Lib "kernel32.dll" () As Long
Private Function log10(x As Double) As Double
    log10 = WorksheetFunction.log10(x)
End Function
Private Function pow(x As Variant, y As Variant) As Double
    pow = WorksheetFunction.Power(x, y)
End Function
Private Sub init(N As Long)
    'Computes a, b and c as the vertices
    '(a,0,0), (0,b,0), (0,0,c) of a tetrahedron
    'with apex (0,0,0) and volume N
    'volume N=a*b*c/6
    Dim k As Double
    k = log10(2) * log10(3) * log10(5) * 6 * N
    k = pow(k, 1 / 3)
    a = k / log10(2)
    b = k / log10(3)
    c = k / log10(5)
    p = -b * c
    q = -a * c
    r = -a * b
End Sub
Private Function x_given_y_z(y As Integer, z As Integer) As Double
    x_given_y_z = -(q * y + r * z + a * b * c) / p
End Function
Private Function cmp(i As Integer, j As Integer, k As Integer, gn() As Integer) As Boolean
    cmp = (i * log10(2) + j * log10(3) + k * log10(5)) > (gn(0) * log10(2) + gn(1) * log10(3) + gn(2) * log10(5))
End Function
Private Function count(N As Long, step As Integer) As Long
    'Loop over y and z, compute x and
    'count number of lattice points within tetrahedron.
    'Step 1 is indirectly called by find_seed to calibrate the plane through A, B and C
    'Step 2 fills the matrix cnt with the number of lattice points given the exponents of 3 and 5
    'Step 3 the plane is lowered marginally so one or two candidates stick out
    Dim M As Long, j As Integer, k As Integer
    If step = 2 Then ReDim cnt(0 To Int(b) + 1, 0 To Int(c) + 1)
    M = 0: j = 0: k = 0
    Do While -c * j - b * k + b * c > 0
        Do While -c * j - b * k + b * c > 0
            Select Case step
                Case 1: M = M + Int(x_given_y_z(j, k))
                Case 2
                    cnt(j, k) = Int(x_given_y_z(j, k))
                Case 3
                    If Int(x_given_y_z(j, k)) < cnt(j, k) Then
                        'This is a candidate, and ...
                        If cmp(cnt(j, k), j, k, hn) Then
                            'it is bigger dan what is already in hn
                            hn(0) = cnt(j, k)
                            hn(1) = j
                            hn(2) = k
                        End If
                    End If
            End Select
            k = k + 1
        Loop
        k = 0
        j = j + 1
    Loop
    count = M
End Function
Private Sub list_upto(ByVal N As Integer)
    Dim count As Integer
    count = 1
    Dim hn As Integer
    hn = 1
    Do While count < N
        k = hn
        Do While k Mod 2 = 0
            k = k / 2
        Loop
        Do While k Mod 3 = 0
            k = k / 3
        Loop
        Do While k Mod 5 = 0
            k = k / 5
        Loop
        If k = 1 Then
            Debug.Print hn; " ";
            count = count + 1
        End If
        hn = hn + 1
    Loop
    Debug.Print
End Sub
Private Function find_seed(N As Long, step As Integer) As Long
    Dim initial As Long, total As Long
    initial = N
    Do 'a simple iterative goal search, takes a handful iterations only
        init initial
        total = count(initial, step)
        initial = initial + N - total
    Loop Until total = N
    find_seed = initial
End Function
Private Sub find_hn(N As Long)
    Dim fs As Long, err As Long
    'Step 1: find fs such that the number of lattice points is exactly N
    fs = find_seed(N, 1)
    'Step 2: fill the matrix cnt
    init fs
    err = count(fs, 2)
    'Step 3: lower the plane by diminishing fs, the candidates for
    'the Nth Hamming number will stick out and be recorded in hn
    init fs - 1
    err = count(fs - 1, 3)
    Debug.Print "2^" & hn(0) - 1; " * 3^" & hn(1); " * 5^" & hn(2); "=";
    If N < 1692 Then
        'The task set a limit on the number size
        Debug.Print pow(2, hn(0) - 1) * pow(3, hn(1)) * pow(5, hn(2))
    Else
        Debug.Print
        If N <= 1000000 Then
            'The big Hamming Number will end in a lot of zeroes. The common exponents of 2 and 5
            'are split off to be printed separately.
            If hn(0) - 1 < hn(2) Then
                'Conversion to Decimal datatype with CDec allows to print numbers upto 10^28
                Debug.Print CDec(pow(3, hn(1))) * CDec(pow(5, hn(2) - hn(0) + 1)) & String$(hn(0) - 1, "0")
            Else
                Debug.Print CDec(pow(2, hn(0) - 1 - hn(2))) * CDec(pow(3, hn(1))) & String$(hn(2), "0")
            End If
        End If
    End If
End Sub
Public Sub main()
    Dim start_time As Long, finis_time As Long
    start_time = GetTickCount
    Debug.Print "The first twenty Hamming numbers are:"
    list_upto 20
    Debug.Print "Hamming number 1691 is: ";
    find_hn 1691
    Debug.Print "Hamming number 1000000 is: ";
    find_hn 1000000
    finis_time = GetTickCount
    Debug.Print "Execution time"; (finis_time - start_time); " milliseconds"
End Sub
