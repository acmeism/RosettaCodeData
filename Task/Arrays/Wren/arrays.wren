var arr = []
arr.add(1)
arr.add(2)
arr.count // 2
arr.clear()

arr.add(0)
arr.add(arr[0])
arr.add(1)
arr.add(arr[-1])  // [0, 0, 1, 1]

arr[-1] = 0
arr.insert(-1, 0) // [0, 0, 1, 0, 0]
arr.removeAt(2)   // [0, 0, 0, 0]
