from strutils import `%`

const numDoors = 100
var doors: array[1..numDoors, bool]

for pass in 1..numDoors:
  for door in countup(pass, numDoors, pass):
    doors[door] = not doors[door]

for door in 1..numDoors:
  echo "Door $1 is $2." % [$door, if doors[door]: "open" else: "closed"]
