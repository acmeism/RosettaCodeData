width = int(raw_input("Width of myarray: "))
height = int(raw_input("Height of Array: "))
myarray = [[0] * width for i in range(height)]
myarray[0][0] = 3.5
print (myarray[0][0])
