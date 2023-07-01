arr = [1,2,3,4,5]
p sum = arr.inject(0, :+)         #=> 15
p product = arr.inject(1, :*)     #=> 120

# If you do not explicitly specify an initial value for memo,
# then the first element of collection is used as the initial value of memo.
p sum = arr.inject(:+)            #=> 15
p product = arr.inject(:*)        #=> 120
