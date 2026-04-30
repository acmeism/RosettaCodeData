'Arrays - VBScript - 08/02/2021

    'create a static array
    Dim a(3)   ' 4 items : a(0), a(1), a(2), a(3)
    'assign a value to elements
    For i = 1 To 3
        a(i) = i * i
    Next
    'and retrieve elements
	buf=""
    For i = 1 To 3
        buf = buf & a(i) & " "
    Next
    WScript.Echo buf
	
    'create a dynamic array
    Dim d()
    ReDim d(3)   ' 4 items : d(0), d(1), d(2), d(3)
    For i = 1 To 3
        d(i) = i * i
    Next
	buf=""
    For i = 1 To 3
        buf = buf & d(i) & " "
    Next
	WScript.Echo buf
	
	d(0) = 0
    'expand the array and preserve existing values
    ReDim Preserve d(4)   ' 5 items : d(0), d(1), d(2), d(3), d(4)
    d(4) = 16
	buf=""
    For i = LBound(d) To UBound(d)
        buf = buf & d(i) & " "
    Next
	WScript.Echo buf

	'create and initialize an array dynamicaly
    b = Array(1, 4, 9)
	'and retrieve all elements
	WScript.Echo Join(b,",")

	'Multi-Dimensional arrays
	'The following creates a 5x4 matrix
	Dim mat(4,3)
