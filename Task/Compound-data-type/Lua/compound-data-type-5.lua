a = newPoint(1, 2)
b = newPoint(3, 4)
c = a + b             -- using __add behaviour
print(a:getXY())      --> 1 2
print(type(a))        --> point
print(c:getXY())      --> 4 6
print((a-b):getXY())  --> -2 -2  -- using __sub behaviour
