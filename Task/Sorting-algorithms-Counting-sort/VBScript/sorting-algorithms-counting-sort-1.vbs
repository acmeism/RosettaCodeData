function findMax( a )
	dim num
	dim max
	max = 0
	for each num in a
		if num > max then max = num
	next
	findMax = max
end function

function findMin( a )
	dim num
	dim min
	min = 0
	for each num in a
		if num < min then min = num
	next
	findMin = min
end function

'the function returns the sorted array, but the fact is that VBScript passes the array by reference anyway
function countingSort( a )
	dim count()
	dim min, max
	min = findMin(a)
	max = findMax(a)
	redim count( max - min + 1 )
	dim i
	dim z
	for i = 0 to ubound( a )
		count( a(i) - min ) = count( a( i ) - min ) + 1
	next
	z = 0
	for i = min to max
		while count( i - min) > 0
			a(z) = i
			z = z + 1
			count( i - min ) = count( i - min ) - 1
		wend
	next
	countingSort = a
end function
