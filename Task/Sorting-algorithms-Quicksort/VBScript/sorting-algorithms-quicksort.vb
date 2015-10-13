Function quicksort(arr,s,n)
	l = s
	r = s + n - 1
	p = arr(Int((l + r)/2))
	Do Until l > r
		Do While arr(l) < p
			l = l + 1
		Loop
		Do While arr(r) > p
			r = r -1
		Loop
		If l <= r Then
			tmp = arr(l)
			arr(l) = arr(r)
			arr(r) = tmp
			l = l + 1
			r = r - 1
		End If
	Loop
	If s < r Then
		Call quicksort(arr,s,r-s+1)
	End If
	If l < t Then
		Call quicksort(arr,l,t-l+1)
	End If
	quicksort = arr
End Function

myarray=Array(9,8,7,6,5,5,4,3,2,1,0,-1)
m = quicksort(myarray,0,12)
WScript.Echo Join(m,",")
