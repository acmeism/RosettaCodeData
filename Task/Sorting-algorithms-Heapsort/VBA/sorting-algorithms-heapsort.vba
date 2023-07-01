Sub SiftDown(list() As Integer, start As Long, eend As Long)
	Dim root As Long : root = start
	Dim lb As Long : lb = LBound(list)
	Dim temp As Integer

	While root * 2 + 1 <= eend
		Dim child As Long : child = root * 2 + 1
		If child + 1 <= eend Then
			If list(lb + child) < list(lb + child + 1) Then
				child = child + 1
			End If
		End If
		If list(lb + root) < list(lb + child) Then
			temp = list(lb + root)
			list(lb + root) = list(lb + child)
			list(lb + child) = temp

			root = child
		Else
			Exit Sub
		End If
	Wend
End Sub

Sub HeapSort(list() As Integer)
	Dim lb As Long : lb = LBound(list)
	Dim count As Long : count = UBound(list) - lb + 1
	Dim start As Long : start = (count - 2) \ 2
	Dim eend As Long : eend = count - 1

	While start >= 0
		SiftDown list(), start, eend
		start = start - 1
	Wend
	
	Dim temp As Integer

	While eend > 0
		temp = list(lb + eend)
		list(lb + eend) = list(lb)
		list(lb) = temp

		eend = eend - 1

		SiftDown list(), 0, eend
	Wend
End Sub
