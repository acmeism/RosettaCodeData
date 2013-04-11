print('Enter the first number: ')
a = tonumber(io.stdin:read())
print('Enter the second number: ')
b = tonumber(io.stdin:read())

if a < b then print(a .. " is less than " .. b) end
if a > b then print(a .. " is greater than " .. b) end
if a == b then print(a .. " is equal to " .. b) end
