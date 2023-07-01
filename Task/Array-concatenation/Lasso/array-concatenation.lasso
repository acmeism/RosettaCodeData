local(arr1 = array(1, 2, 3))
local(arr2 = array(4, 5, 6))
local(arr3 = #arr1->asCopy)	//	make arr3 a copy of arr2
#arr3->merge(#arr2)		//	concatenate 2 arrays


Result:

arr1 = array(1, 2, 3)
arr2 = array(4, 5, 6)
arr3 = array(4, 5, 6)
arr3 = array(1, 2, 3, 4, 5, 6)
