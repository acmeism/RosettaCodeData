import math, sequtils, strformat, strutils

const
  headingNames: array[1..32, string] = [
    "North", "North by east", "North-northeast", "Northeast by north",
    "Northeast", "Northeast by east", "East-northeast", "East by north",
    "East", "East by south", "East-southeast", "Southeast by east",
    "Southeast", "Southeast by south","South-southeast", "South by east",
    "South", "South by west", "South-southwest", "Southwest by south",
    "Southwest", "Southwest by west", "West-southwest", "West by south",
    "West", "West by north", "West-northwest", "Northwest by west",
    "Northwest", "Northwest by north", "North-northwest", "North by west"]
  maxNameLength = headingNames.mapIt(it.len).max
  degreesPerHeading = 360 / 32

func toCompassIndex(degree: float): 1..32 =
  var degree = (degree + degreesPerHeading / 2).floorMod 360
  int(degree / degreesPerHeading) + 1

func toCompassHeading(degree: float): string = headingNames[degree.toCompassIndex]

for i in 0..32:
  let
    heading = float(i) * 11.25 + (case i mod 3
      of 1: 5.62
      of 2: -5.62
      else: 0)
    index = heading.toCompassIndex
    compassHeading = heading.toCompassHeading.alignLeft(maxNameLength)
  echo fmt"{index:>2} {compassHeading} {heading:6.2f}"
