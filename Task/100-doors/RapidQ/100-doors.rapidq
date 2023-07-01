dim x as integer, y as integer
dim door(1 to 100) as byte

'initialize array
for x = 1 to 100 : door(x) = 0 : next

'set door values
for y = 1 to 100
    for x = y to 100 step y
        door(x) = not door(x)
    next x
next y

'print result
for x = 1 to 100
    if door(x) then print "Door " + str$(x) + " = open"
next

while inkey$="":wend
end
