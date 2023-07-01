? def bstr := [].diverge(int8)
# value: [].diverge()

? def bstr1 := [1,2,3].diverge(int8)
# value: [1, 2, 3].diverge()

? def bstr2 := [-0x7F,0x2,0x3].diverge(int8)
# value: [-127, 2, 3].diverge()
