? def flex := numbers.diverge()
# value: [1, 2].diverge()

? flex.push(-3)
? flex
# value: [1, 2, -3].diverge()

? numbers
# value: [1, 2]

? flex.snapshot()
# value: [1, 2, -3]
