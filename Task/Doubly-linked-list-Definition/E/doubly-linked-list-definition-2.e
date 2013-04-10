? def list := makeDLList()
# value: <>

? list.push(1)
? list
# value: <1>

? list.push(10)
? list.push(100)
? list
# value: <1, 10, 100>

? list.atFirst().insertAfter(5)
? list
# value: <1, 5, 10, 100>

? list.insertFirst(0)
? list
# value: <0, 1, 5, 10, 100>

? list.atLast().prev().remove()
? list
# value: <0, 1, 5, 100>

? list.atLast()[] := 10
? list
# value: <0, 1, 5, 10>

? for x in 11..20 { list.push(x) }
? list
# value: <0, 1, 5, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20>
