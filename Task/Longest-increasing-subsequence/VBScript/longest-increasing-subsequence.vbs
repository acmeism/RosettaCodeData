Function LIS(arr)
	n = UBound(arr)
	Dim p()
	ReDim p(n)
	Dim m()
	ReDim m(n)
	l = 0
	For i = 0 To n
		lo = 1
		hi = l
		Do While lo <= hi
			middle = Int((lo+hi)/2)
			If arr(m(middle)) < arr(i) Then
				lo = middle + 1
			Else
				hi = middle - 1
			End If
		Loop
		newl = lo
		p(i) = m(newl-1)
		m(newl) = i
		If newL > l Then
			l = newl
		End If
	Next
	Dim s()
	ReDim s(l)
	k = m(l)
	For i = l-1 To 0 Step - 1
		s(i) = arr(k)
		k = p(k)
	Next
	LIS = Join(s,",")
End Function

WScript.StdOut.WriteLine LIS(Array(3,2,6,4,5,1))
WScript.StdOut.WriteLine LIS(Array(0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15))
