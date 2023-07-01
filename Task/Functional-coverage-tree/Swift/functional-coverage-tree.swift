import Foundation

extension String {
  func paddedLeft(totalLen: Int) -> String {
    let needed = totalLen - count

    guard needed > 0 else {
      return self
    }

    return String(repeating: " ", count: needed) + self
  }
}

class FCNode {
  let name: String
  let weight: Int

  var coverage: Double {
    didSet {
      if oldValue != coverage {
        parent?.updateCoverage()
      }
    }
  }

  weak var parent: FCNode?
  var children = [FCNode]()

  init(name: String, weight: Int = 1, coverage: Double = 0) {
    self.name = name
    self.weight = weight
    self.coverage = coverage
  }

  func addChildren(_ children: [FCNode]) {
    for child in children {
      child.parent = self
    }

    self.children += children

    updateCoverage()
  }

  func show(level: Int = 0) {
    let indent = level * 4
    let nameLen = name.count + indent

    print(name.paddedLeft(totalLen: nameLen), terminator: "")
    print("|".paddedLeft(totalLen: 32 - nameLen), terminator: "")
    print(String(format: "  %3d   |", weight), terminator: "")
    print(String(format: " %8.6f |", coverage))

    for child in children {
      child.show(level: level + 1)
    }
  }

  func updateCoverage() {
    let v1 = children.reduce(0.0, { $0 + $1.coverage * Double($1.weight) })
    let v2 = children.reduce(0.0, { $0 + Double($1.weight) })

    coverage = v1 / v2
  }
}

let houses = [
  FCNode(name: "house1", weight: 40),
  FCNode(name: "house2", weight: 60)
]

let house1 = [
  FCNode(name: "bedrooms", weight: 1, coverage: 0.25),
  FCNode(name: "bathrooms"),
  FCNode(name: "attic", weight: 1, coverage: 0.75),
  FCNode(name: "kitchen", weight: 1, coverage: 0.1),
  FCNode(name: "living_rooms"),
  FCNode(name: "basement"),
  FCNode(name: "garage"),
  FCNode(name: "garden", weight: 1, coverage: 0.8)
]

let house2 = [
  FCNode(name: "upstairs"),
  FCNode(name: "groundfloor"),
  FCNode(name: "basement")
]

let h1Bathrooms = [
  FCNode(name: "bathroom1", weight: 1, coverage: 0.5),
  FCNode(name: "bathroom2"),
  FCNode(name: "outside_lavatory", weight: 1, coverage: 1.0)
]

let h1LivingRooms = [
  FCNode(name: "lounge"),
  FCNode(name: "dining_room"),
  FCNode(name: "conservatory"),
  FCNode(name: "playroom", weight: 1, coverage: 1.0)
]

let h2Upstairs = [
  FCNode(name: "bedrooms"),
  FCNode(name: "bathroom"),
  FCNode(name: "toilet"),
  FCNode(name: "attics", weight: 1, coverage: 0.6)
]

let h2Groundfloor = [
  FCNode(name: "kitchen"),
  FCNode(name: "living_rooms"),
  FCNode(name: "wet_room_&_toilet"),
  FCNode(name: "garage"),
  FCNode(name: "garden", weight: 1, coverage: 0.9),
  FCNode(name: "hot_tub_suite", weight: 1, coverage: 1.0)
]

let h2Basement = [
  FCNode(name: "cellars", weight: 1, coverage: 1.0),
  FCNode(name: "wine_cellar", weight: 1, coverage: 1.0),
  FCNode(name: "cinema", weight: 1, coverage: 0.75)
]

let h2UpstairsBedrooms = [
  FCNode(name: "suite_1"),
  FCNode(name: "suite_2"),
  FCNode(name: "bedroom_3"),
  FCNode(name: "bedroom_4")
]

let h2GroundfloorLivingRooms = [
  FCNode(name: "lounge"),
  FCNode(name: "dining_room"),
  FCNode(name: "conservatory"),
  FCNode(name: "playroom")
]

let cleaning = FCNode(name: "cleaning")

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

let top = cleaning.coverage

print("Top Coverage: \(String(format: "%8.6f", top))")
print("Name Hierarchy                 | Weight | Coverage |")

cleaning.show()

h2Basement[2].coverage = 1.0

let diff = cleaning.coverage - top

print("\nIf the coverage of the Cinema node were increased from 0.75 to 1.0")
print("the top level coverage would increase by ")
print("\(String(format: "%8.6f", diff)) to \(String(format: "%8.6f", top))")
