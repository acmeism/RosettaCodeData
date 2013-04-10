doors = []

for pass in [1..100]
  for i in [pass..100] by pass
    doors[i] = !doors[i]

console.log "Doors #{index for index, open of doors when open} are open"

# matrix output
console.log doors.map (open) -> +open
