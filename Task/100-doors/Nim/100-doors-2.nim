from strutils import `%`

const numDoors = 100
var doors {.compileTime.}: array[1..numDoors, bool]

proc calcDoors(): string =
  for pass in 1..numDoors:
    for door in countup(pass, numDoors, pass):
      doors[door] = not doors[door]
  for door in 1..numDoors:
    result.add("Door $1 is $2.\n" % [$door, if doors[door]: "open" else: "closed"])

const outputString: string = calcDoors()

echo outputString
