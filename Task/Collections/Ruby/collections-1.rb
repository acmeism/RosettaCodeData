# creating an empty array and adding values
a = []              #=> []
a[0] = 1            #=> [1]
a[3] = "abc"        #=> [1, nil, nil, "abc"]
a << 3.14           #=> [1, nil, nil, "abc", 3.14]

# creating an array with the constructor
a = Array.new               #=> []
a = Array.new(3)            #=> [nil, nil, nil]
a = Array.new(3, 0)         #=> [0, 0, 0]
a = Array.new(3){|i| i*2}   #=> [0, 2, 4]
