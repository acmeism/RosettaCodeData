for i = 1 to 5000
    if Munch(i) Then
        Wscript.Echo i, "is a Munchausen number"
    end if
next

'Returns True if num is a Munchausen number. This is true if the sum of
'each digit raised to that digit's power is equal to the given number.
'Example: 3435 = 3^3 + 4^4 + 3^3 + 5^5

Function Munch (num)

    dim str: str = Cstr(num)    'input num as a string
    dim sum: sum = 0            'running sum of n^n
    dim i                       'loop index
    dim n                       'extracted digit

    for i = 1 to len(str)
        n = CInt(Mid(str,i,1))
        sum = sum + n^n
    next

    Munch = (sum = num)

End Function
