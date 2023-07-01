package main

import "fmt"

type FCNode struct {
    name     string
    weight   int
    coverage float64
    children []*FCNode
    parent   *FCNode
}

func newFCN(name string, weight int, coverage float64) *FCNode {
    return &FCNode{name, weight, coverage, nil, nil}
}

func (n *FCNode) addChildren(nodes []*FCNode) {
    for _, node := range nodes {
        node.parent = n
        n.children = append(n.children, node)
    }
    n.updateCoverage()
}

func (n *FCNode) setCoverage(value float64) {
    if n.coverage != value {
        n.coverage = value
        // update any parent's coverage
        if n.parent != nil {
            n.parent.updateCoverage()
        }
    }
}

func (n *FCNode) updateCoverage() {
    v1 := 0.0
    v2 := 0
    for _, node := range n.children {
        v1 += float64(node.weight) * node.coverage
        v2 += node.weight
    }
    n.setCoverage(v1 / float64(v2))
}

func (n *FCNode) show(level int) {
    indent := level * 4
    nl := len(n.name) + indent
    fmt.Printf("%*s%*s  %3d   | %8.6f |\n", nl, n.name, 32-nl, "|", n.weight, n.coverage)
    if len(n.children) == 0 {
        return
    }
    for _, child := range n.children {
        child.show(level + 1)
    }
}

var houses = []*FCNode{
    newFCN("house1", 40, 0),
    newFCN("house2", 60, 0),
}

var house1 = []*FCNode{
    newFCN("bedrooms", 1, 0.25),
    newFCN("bathrooms", 1, 0),
    newFCN("attic", 1, 0.75),
    newFCN("kitchen", 1, 0.1),
    newFCN("living_rooms", 1, 0),
    newFCN("basement", 1, 0),
    newFCN("garage", 1, 0),
    newFCN("garden", 1, 0.8),
}

var house2 = []*FCNode{
    newFCN("upstairs", 1, 0),
    newFCN("groundfloor", 1, 0),
    newFCN("basement", 1, 0),
}

var h1Bathrooms = []*FCNode{
    newFCN("bathroom1", 1, 0.5),
    newFCN("bathroom2", 1, 0),
    newFCN("outside_lavatory", 1, 1),
}

var h1LivingRooms = []*FCNode{
    newFCN("lounge", 1, 0),
    newFCN("dining_room", 1, 0),
    newFCN("conservatory", 1, 0),
    newFCN("playroom", 1, 1),
}

var h2Upstairs = []*FCNode{
    newFCN("bedrooms", 1, 0),
    newFCN("bathroom", 1, 0),
    newFCN("toilet", 1, 0),
    newFCN("attics", 1, 0.6),
}

var h2Groundfloor = []*FCNode{
    newFCN("kitchen", 1, 0),
    newFCN("living_rooms", 1, 0),
    newFCN("wet_room_&_toilet", 1, 0),
    newFCN("garage", 1, 0),
    newFCN("garden", 1, 0.9),
    newFCN("hot_tub_suite", 1, 1),
}

var h2Basement = []*FCNode{
    newFCN("cellars", 1, 1),
    newFCN("wine_cellar", 1, 1),
    newFCN("cinema", 1, 0.75),
}

var h2UpstairsBedrooms = []*FCNode{
    newFCN("suite_1", 1, 0),
    newFCN("suite_2", 1, 0),
    newFCN("bedroom_3", 1, 0),
    newFCN("bedroom_4", 1, 0),
}

var h2GroundfloorLivingRooms = []*FCNode{
    newFCN("lounge", 1, 0),
    newFCN("dining_room", 1, 0),
    newFCN("conservatory", 1, 0),
    newFCN("playroom", 1, 0),
}

func main() {
    cleaning := newFCN("cleaning", 1, 0)

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
    topCoverage := cleaning.coverage
    fmt.Printf("TOP COVERAGE = %8.6f\n\n", topCoverage)
    fmt.Println("NAME HIERARCHY                 | WEIGHT | COVERAGE |")
    cleaning.show(0)

    h2Basement[2].setCoverage(1) // change Cinema node coverage to 1
    diff := cleaning.coverage - topCoverage
    fmt.Println("\nIf the coverage of the Cinema node were increased from 0.75 to 1")
    fmt.Print("the top level coverage would increase by ")
    fmt.Printf("%8.6f to %8.6f\n", diff, topCoverage+diff)
    h2Basement[2].setCoverage(0.75) // restore to original value if required
}
