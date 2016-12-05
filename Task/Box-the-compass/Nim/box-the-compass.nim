import strfmt

const names = [
  "North", "North by east", "North-northeast", "Northeast by north",
  "Northeast", "Northeast by east", "East-northeast", "East by north",
  "East", "East by south", "East-southeast", "Southeast by east",
  "Southeast", "Southeast by south","South-southeast", "South by east",
  "South", "South by west", "South-southwest", "Southwest by south",
  "Southwest", "Southwest by west", "West-southwest", "West by south",
  "West", "West by north", "West-northwest", "Northwest by west",
  "Northwest", "Northwest by north", "North-northwest", "North by west", "North"]

for i in 0..32:
  let j = i mod 32
  var d = float(i) * 11.25
  if i mod 3 == 1: d += 5.62
  if i mod 3 == 2: d -= 5.62
  printlnfmt "{:2} {:18} {:>6.2f}", j + 1, names[j], d
