doors = list(100)
for i = 1 to 100
doors[i] = false
next

For p = 1 To 10
        doors[pow(p,2)] = True
Next

For door = 1 To 100
     see "Door (" + door + ") is "
     If doors[door] see "Open" else see "Closed" ok
     see nl
Next
