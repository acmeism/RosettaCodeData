arr1 = [1, 2, 3]
arr2 = [4, 5, 6]
arr3 = [7, 8, 9]
arr4 = arr1 + arr2
assert arr4 == [1, 2, 3, 4, 5, 6]
arr4.extend(arr3)
assert arr4 == [1, 2, 3, 4, 5, 6, 7, 8, 9]
