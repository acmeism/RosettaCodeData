? def l := [].diverge()
# value: [].diverge()

? l.push(1)
? l.push(2)
? l
# value: [1, 2].diverge()

? l.pop()
# value: 2

? l.size().aboveZero()
# value: true

? l.last()
# value: 1

? l.pop()
# value: 1

? l.size().aboveZero()
# value: false
