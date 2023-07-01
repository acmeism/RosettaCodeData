import algorithm

type

  Person {.pure.} = enum Baker, Cooper, Fletcher, Miller, Smith
  Floor = range[1..5]

var floors: array[Person, Floor] = [Floor 1, 2, 3, 4, 5]

while true:
  if floors[Baker] != 5 and
     floors[Cooper] != 1 and
     floors[Fletcher] notin [1, 5] and
     floors[Miller] > floors[Cooper] and
     abs(floors[Smith] - floors[Fletcher]) != 1 and
     abs(floors[Fletcher] - floors[Cooper]) != 1:
       for person, floor in floors:
         echo person, " lives on floor ", floor
       break
  if not floors.nextPermutation():
    echo "No solution found."
    break
