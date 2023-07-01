? def a := [1].diverge()
# value: [1].diverge()

? def b := copy(a)
# value: [1].diverge()

? b.push(2)
? a
# value: [1].diverge()

? b
# value: [1, 2].diverge()
