#include "isprime.bas"

Const lim As Integer = 2500
Dim As Integer pbnp(lim)
Dim As Integer n, base_, d, c, tc, oc, ec
Dim As String digits
Dim As Boolean composite

For n = 3 To lim
    digits = Str(n)
    composite = True
    For base_ = 2 To n
        d = 0
        For c = 1 To Len(digits)
            d = d * base_ + Val(Mid(digits, c, 1))
        Next c
        If IsPrime(d) Then
            composite = False
            Exit For
        End If
    Next base_
    If composite Then
        tc += 1
        pbnp(tc) = n
        If n Mod 2 <> 0 Then oc += 1
    End If
Next n

ec = tc - oc

Print "First 50 pan-base composites:"
For n = 1 To 50
    Print Using "### "; pbnp(n);
	If n Mod 10 = 0 Then Print
Next n

Print !"\nFirst 20 odd pan-base composites:"
c = 0
For n = 1 To 115
    If pbnp(n) Mod 2 Then
        Print Using "### "; pbnp(n);
        'Print Using "### "; odds(n);
        c += 1
        If c Mod 10 = 0 Then Print
    End If
Next n

Print !"\nCount of pan-base_ composites up to and including "; lim; ": "; tc
Print Using "Number odd  = ### or ##.######%"; oc; oc/tc*100
Print Using "Number even = ### or ##.######%"; ec; ec/tc*100

Sleep
