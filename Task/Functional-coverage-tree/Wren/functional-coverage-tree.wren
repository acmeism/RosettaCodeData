import "/fmt" for Fmt

class FCNode {
    construct new(name, weight, coverage) {
        _name = name
        _weight = weight
        _coverage = coverage
        _children = []
        _parent = null
    }

    static new(name, weight) { new(name, weight, 0) }
    static new(name)         { new(name, 1, 0) }

    name     { _name }
    weight   { _weight }
    coverage { _coverage }

    coverage=(value) {
        if (_coverage != value) {
            _coverage = value
            if (_parent) {
                _parent.updateCoverage_() // update any parent's coverage
            }
        }
    }

    parent     { _parent }
    parent=(p) { _parent = p }

    addChildren(nodes) {
        _children.addAll(nodes)
        for (node in nodes) node.parent = this
        updateCoverage_()
    }

    updateCoverage_() {
        var v1 = _children.reduce(0) { |acc, n| acc + n.weight * n.coverage }
        var v2 = _children.reduce(0) { |acc, n| acc + n.weight }
        coverage = v1 / v2
    }

    show(level) {
        var indent = level * 4
        var nl = _name.count + indent
        Fmt.lprint("$*s$*s  $3d   | $8.6f |", [nl, _name, 32-nl, "|", _weight, _coverage])
        if (_children.isEmpty) return
        for (child in _children) child.show(level+1)
    }
}

var houses = [
    FCNode.new("house1", 40),
    FCNode.new("house2", 60)
]

var house1 = [
    FCNode.new("bedrooms", 1, 0.25),
    FCNode.new("bathrooms"),
    FCNode.new("attic", 1, 0.75),
    FCNode.new("kitchen", 1, 0.1),
    FCNode.new("living_rooms"),
    FCNode.new("basement"),
    FCNode.new("garage"),
    FCNode.new("garden", 1, 0.8)
]

var house2 = [
    FCNode.new("upstairs"),
    FCNode.new("groundfloor"),
    FCNode.new("basement")
]

var h1Bathrooms = [
    FCNode.new("bathroom1", 1, 0.5),
    FCNode.new("bathroom2"),
    FCNode.new("outside_lavatory", 1, 1)
]

var h1LivingRooms = [
    FCNode.new("lounge"),
    FCNode.new("dining_room"),
    FCNode.new("conservatory"),
    FCNode.new("playroom", 1, 1)
]

var h2Upstairs = [
    FCNode.new("bedrooms"),
    FCNode.new("bathroom"),
    FCNode.new("toilet"),
    FCNode.new("attics", 1, 0.6)
]

var h2Groundfloor = [
    FCNode.new("kitchen"),
    FCNode.new("living_rooms"),
    FCNode.new("wet_room_&_toilet"),
    FCNode.new("garage"),
    FCNode.new("garden", 1, 0.9),
    FCNode.new("hot_tub_suite", 1, 1)
]

var h2Basement = [
    FCNode.new("cellars", 1, 1),
    FCNode.new("wine_cellar", 1, 1),
    FCNode.new("cinema", 1, 0.75)
]

var h2UpstairsBedrooms = [
    FCNode.new("suite_1"),
    FCNode.new("suite_2"),
    FCNode.new("bedroom_3"),
    FCNode.new("bedroom_4")
]

var h2GroundfloorLivingRooms = [
    FCNode.new("lounge"),
    FCNode.new("dining_room"),
    FCNode.new("conservatory"),
    FCNode.new("playroom")
]

var cleaning = FCNode.new("cleaning")

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
var topCoverage = cleaning.coverage
Fmt.print("TOP COVERAGE = $8.6f\n", topCoverage)
System.print("NAME HIERARCHY                 | WEIGHT | COVERAGE |")
cleaning.show(0)

h2Basement[2].coverage = 1 // change Cinema node coverage to 1
var diff = cleaning.coverage - topCoverage
System.print("\nIf the coverage of the Cinema node were increased from 0.75 to 1")
System.write("the top level coverage would increase by ")
Fmt.print("$8.6f to $8.6f", diff, topCoverage + diff)
h2Basement[2].coverage = 0.75  // restore to original value if required
