Function pf(p)
    If p < 0.06 Then
        pf = 0.10
    ElseIf p < 0.11 Then
    	pf = 0.18
    ElseIf p < 0.16 Then
    	pf = 0.26
    ElseIf p < 0.21 Then
    	pf = 0.32
    ElseIf p < 0.26 Then
    	pf = 0.38
    ElseIf p < 0.31 Then
    	pf = 0.44
    ElseIf p < 0.36 Then
    	pf = 0.50
    ElseIf p < 0.41 Then
    	pf = 0.54
    ElseIf p < 0.46 Then
    	pf = 0.58
    ElseIf p < 0.51 Then
    	pf = 0.62
    ElseIf p < 0.56 Then
    	pf = 0.66
    ElseIf p < 0.61 Then
    	pf = 0.70
    ElseIf p < 0.66 Then
    	pf = 0.74
    ElseIf p < 0.71 Then
    	pf = 0.78
    ElseIf p < 0.76 Then
    	pf = 0.82
    ElseIf p < 0.81 Then
    	pf = 0.86
    ElseIf p < 0.86 Then
    	pf = 0.90
    ElseIf p < 0.91 Then
    	pf = 0.94
    ElseIf p < 0.96 Then
    	pf = 0.98
    Else
    	pf = 1.00
    End If
End Function

WScript.Echo pf(0.7388727)
WScript.Echo pf(0.8593103)
WScript.Echo pf(0.826687)
WScript.Echo pf(0.3444635)
