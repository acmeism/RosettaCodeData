arr = [1,2,3,4,5]
sum = arr.inject(0, :+)
# => 15
product = arr.inject(1, :*)
# => 120
