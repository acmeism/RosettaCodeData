'Solution derived from http://www.geeksforgeeks.org/sort-an-array-of-0s-1s-and-2s/.

'build an unsorted array with n elements
Function build_unsort(n)
	flag = Array("red","white","blue")
	Set random = CreateObject("System.Random")
	Dim arr()
	ReDim arr(n)
	For i = 0 To n
		arr(i) = flag(random.Next_2(0,3))
	Next
	build_unsort = arr
End Function

'sort routine
Function sort(arr)
	lo = 0
	mi = 0
	hi = UBound(arr)
	Do While mi <= hi
		Select Case arr(mi)
			Case "red"
				tmp = arr(lo)
				arr(lo) = arr(mi)
				arr(mi) = tmp
				lo = lo + 1
				mi = mi + 1
			Case "white"
				mi = mi + 1
			Case "blue"
				tmp = arr(mi)
				arr(mi) = arr(hi)
				arr(hi) = tmp
				hi = hi - 1
		End Select
	Loop
	sort = Join(arr,",")
End Function

unsort = build_unsort(11)
WScript.StdOut.Write "Unsorted: " & Join(unsort,",")
WScript.StdOut.WriteLine
WScript.StdOut.Write "Sorted: " & sort(unsort)
WScript.StdOut.WriteLine
