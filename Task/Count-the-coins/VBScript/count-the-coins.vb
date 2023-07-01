Function count(coins,m,n)
	ReDim table(n+1)
	table(0) = 1
	i = 0
	Do While i < m
		j = coins(i)
		Do While j <= n
			table(j) = table(j) + table(j - coins(i))
			j = j + 1
		Loop
		i = i + 1
	Loop
	count = table(n)
End Function

'testing
arr = Array(1,5,10,25)
m = UBound(arr) + 1
n = 100
WScript.StdOut.WriteLine count(arr,m,n)
