import strformat, strutils

type

  FCNode = ref object
    name: string
    weight: int
    coverage: float
    children: seq[FCNode]
    parent: FCNode

func newFCNode(name: string; weight: int; coverage: float): FCNode =
  FCNode(name: name, weight: weight, coverage: coverage)

# Forward reference.
func updateCoverage(n: FCNode)

func addChildren(n: FCNode; nodes: openArray[FCNode]) =
  for node in nodes:
    node.parent = n
  n.children = @nodes
  n.updateCoverage()

func setCoverage(n: FCNode; value: float) =
  if n.coverage != value:
    n.coverage = value
    # Update any parent's coverage.
    if not n.parent.isNil:
      n.parent.updateCoverage()

func updateCoverage(n: FCNode) =
  var v1 = 0.0
  var v2 = 0
  for node in n.children:
    v1 += node.weight.toFloat * node.coverage
    v2 += node.weight
  n.setCoverage(v1 / v2.toFloat)

proc show(n: FCNode; level: int) =
  let indent = level * 4
  let nl = n.name.len + indent
  const Sep = "|"
  echo &"{n.name.align(nl)}{Sep.align(32-nl)}  {n.weight:>3d}   | {n.coverage:8.6f} |"
  for child in n.children:
    child.show(level + 1)

#———————————————————————————————————————————————————————————————————————————————————————————————————

let houses = [newFCNode("house1", 40, 0), newFCNode("house2", 60, 0)]

let house1 = [
    newFCNode("bedrooms", 1, 0.25),
    newFCNode("bathrooms", 1, 0),
    newFCNode("attic", 1, 0.75),
    newFCNode("kitchen", 1, 0.1),
    newFCNode("living_rooms", 1, 0),
    newFCNode("basement", 1, 0),
    newFCNode("garage", 1, 0),
    newFCNode("garden", 1, 0.8)]

let house2 = [
    newFCNode("upstairs", 1, 0),
    newFCNode("groundfloor", 1, 0),
    newFCNode("basement", 1, 0)]

let h1Bathrooms = [
    newFCNode("bathroom1", 1, 0.5),
    newFCNode("bathroom2", 1, 0),
    newFCNode("outside_lavatory", 1, 1)]

let h1LivingRooms = [
    newFCNode("lounge", 1, 0),
    newFCNode("dining_room", 1, 0),
    newFCNode("conservatory", 1, 0),
    newFCNode("playroom", 1, 1)]

let h2Upstairs = [
    newFCNode("bedrooms", 1, 0),
    newFCNode("bathroom", 1, 0),
    newFCNode("toilet", 1, 0),
    newFCNode("attics", 1, 0.6)]

let h2Groundfloor = [
    newFCNode("kitchen", 1, 0),
    newFCNode("living_rooms", 1, 0),
    newFCNode("wet_room_&_toilet", 1, 0),
    newFCNode("garage", 1, 0),
    newFCNode("garden", 1, 0.9),
    newFCNode("hot_tub_suite", 1, 1)]

let h2Basement = [
    newFCNode("cellars", 1, 1),
    newFCNode("wine_cellar", 1, 1),
    newFCNode("cinema", 1, 0.75)]

let h2UpstairsBedrooms = [
    newFCNode("suite_1", 1, 0),
    newFCNode("suite_2", 1, 0),
    newFCNode("bedroom_3", 1, 0),
    newFCNode("bedroom_4", 1, 0)]

let h2GroundfloorLivingRooms = [
    newFCNode("lounge", 1, 0),
    newFCNode("dining_room", 1, 0),
    newFCNode("conservatory", 1, 0),
    newFCNode("playroom", 1, 0)]

let cleaning = newFCNode("cleaning", 1, 0)

house1[1].addChildren(h1Bathrooms)
house1[4].addChildren(h1LivingRooms)
houses[0].addChildren(house1)

h2Upstairs[0].addChildren(h2UpstairsBedrooms)
house2[0].addChildren(h2Upstairs)
h2Groundfloor[1].addChildren(h2GroundfloorLivingRooms)
house2[1].addChildren(h2Groundfloor)
house2[2].addChildren(h2Basement)
houses[1].addChildren(house2)

cleaning.addChildren(houses)
let topCoverage = cleaning.coverage
echo &"TOP COVERAGE = {topCoverage:8.6f}\n"
echo "NAME HIERARCHY                 | WEIGHT | COVERAGE |"
cleaning.show(0)

h2Basement[2].setCoverage(1)  # Change Cinema node coverage to 1.
let diff = cleaning.coverage - topCoverage
echo "\nIf the coverage of the Cinema node were increased from 0.75 to 1"
echo &"the top level coverage would increase by {diff:8.6f} to {topCoverage + diff:8.6f}"
h2Basement[2].setCoverage(0.75)   # Restore to original value if required.
