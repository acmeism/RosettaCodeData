Dim As Uinteger i = 0, c = 0, j = 0
Dim As Integer l
Dim As Uinteger nums(50)
Dim As Integer lastDigs(9)
Dim As String prev = "zero", sgte = ""
Dim As Uinteger limit = 1000
While limit <= 1000000
    sgte = numname(i+1)
    If Right(prev,1) = Left(sgte,1) Then
        If c < 50 Then nums(c) = i
        Dim As Integer ld = i Mod 10
        lastDigs(ld) += 1
        c += 1
        If c = 50 Then
            Print "First 50 numbers:"
            For j = 0 To c-1
                Print Using "### "; nums(j);
                If (j+1) Mod 10 = 0 Then Print
            Next j
        Elseif c = limit Then
            Print Using !"\nThe & number is ##,###,###."; numname(c); i
            Print !"Breakdown by last digit of the qualifiers up to this:\nFrequencies"
            Print String (80, "-")
            For j = 0 To 9
                l =  Cint(lastDigs(j) * 28 / lastDigs(9))
                Print j; " "; String(l, Chr(254)); " "; lastDigs(j)
            Next j
            Print String (80, "-")
            limit *= 10
        End If
    End If
    prev = sgte
    i += 1
Wend

Sleep
