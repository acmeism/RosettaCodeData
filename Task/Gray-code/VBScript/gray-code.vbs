Function Encoder(ByVal n)
    Encoder = n Xor (n \ 2)
End Function

Function Decoder(ByVal n)
    Dim g : g = 0
    Do While n > 0
       g = g Xor n
       n = n \ 2
    Loop
    Decoder = g
End Function

' Decimal to Binary
Function Dec2bin(ByVal n, ByVal length)
    Dim i, strbin : strbin = ""
    For i = 1 to 5
        strbin = (n Mod 2) & strbin
        n = n \ 2
    Next
    Dec2Bin = strbin
End Function

WScript.StdOut.WriteLine("Binary -> Gray Code -> Binary")
For i = 0 to 31
    encoded = Encoder(i)
    decoded = Decoder(encoded)
    WScript.StdOut.WriteLine(Dec2Bin(i, 5) & " -> " & Dec2Bin(encoded, 5) & " -> " & Dec2Bin(decoded, 5))
Next
