local a = {10}
local b = a

print ("address a:"..tostring(a), "value a:"..a[1])
print ("address b:"..tostring(b), "value b:"..b[1])

b[1] = 42

print ("address a:"..tostring(a), "value a:"..a[1])
print ("address b:"..tostring(b), "value b:"..b[1])
