    Dim sieve()
	If WScript.Arguments.Count>=1 Then
	    n = WScript.Arguments(0)
	Else
	    n = 99
	End If
    ReDim sieve(n)
    For i = 1 To n
        sieve(i) = True
    Next
    For i = 2 To n
        If sieve(i) Then
            For j = i * 2 To n Step i
                sieve(j) = False
            Next
        End If
    Next
    For i = 2 To n
        If sieve(i) Then WScript.Echo i
    Next
