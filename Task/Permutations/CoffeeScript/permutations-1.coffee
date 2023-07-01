# Returns a copy of an array with the element at a specific position
# removed from it.
arrayExcept = (arr, idx) ->
	res = arr[0..]
	res.splice idx, 1
	res

# The actual function which returns the permutations of an array-like
# object (or a proper array).
permute = (arr) ->
	arr = Array::slice.call arr, 0
	return [[]] if arr.length == 0
	
	permutations = (for value,idx in arr
		[value].concat perm for perm in permute arrayExcept arr, idx)
	
	# Flatten the array before returning it.
	[].concat permutations...
