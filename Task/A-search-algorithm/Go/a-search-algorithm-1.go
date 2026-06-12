// Package astar implements the A* search algorithm with minimal constraints
// on the graph representation.
package astar

import "container/heap"

// Exported node type.
type Node interface {
    To() []Arc               // return list of arcs from this node to another
    Heuristic(from Node) int // heuristic cost from another node to this one
}

// An Arc, actually a "half arc", leads to another node with integer cost.
type Arc struct {
    To   Node
    Cost int
}

// rNode holds data for a "reached" node
type rNode struct {
    n    Node
    from Node
    l    int // route len
    g    int // route cost
    f    int // "g+h", route cost + heuristic estimate
    fx   int // heap.Fix index
}

type openHeap []*rNode // priority queue

// Route computes a route from start to end nodes using the A* algorithm.
//
// The algorithm is general A*, where the heuristic is not required to be
// monotonic.  If a route exists, the function will find a route regardless
// of the quality of the Heuristic.  For an admissiable heuristic, the route
// will be optimal.
func Route(start, end Node) (route []Node, cost int) {
    // start node initialized with heuristic
    cr := &rNode{n: start, l: 1, f: end.Heuristic(start)}
    // maintain a set of reached nodes.  start is reached initially
    r := map[Node]*rNode{start: cr}
    // oh is a heap of nodes "open" for exploration.  nodes go on the heap
    // when they get an initial or new "g" route distance, and therefore a
    // new "f" which serves as priority for exploration.
    oh := openHeap{cr}
    for len(oh) > 0 {
        bestRoute := heap.Pop(&oh).(*rNode)
        bestNode := bestRoute.n
        if bestNode == end {
            // done.  prepare return values
            cost = bestRoute.g
            route = make([]Node, bestRoute.l)
            for i := len(route) - 1; i >= 0; i-- {
                route[i] = bestRoute.n
                bestRoute = r[bestRoute.from]
            }
            return
        }
        l := bestRoute.l + 1
        for _, to := range bestNode.To() {
            // "g" route distance from start
            g := bestRoute.g + to.Cost
            if alt, ok := r[to.To]; !ok {
                // alt being reached for the first time
                alt = &rNode{n: to.To, from: bestNode, l: l,
                    g: g, f: g + end.Heuristic(to.To)}
                r[to.To] = alt
                heap.Push(&oh, alt)
            } else {
                if g >= alt.g {
                    continue // candidate route no better than existing route
                }
                // it's a better route
                // update data and make sure it's on the heap
                alt.from = bestNode
                alt.l = l
                alt.g = g
                alt.f = end.Heuristic(alt.n)
                if alt.fx < 0 {
                    heap.Push(&oh, alt)
                } else {
                    heap.Fix(&oh, alt.fx)
                }
            }
        }
    }
    return nil, 0
}

// implement container/heap
func (h openHeap) Len() int           { return len(h) }
func (h openHeap) Less(i, j int) bool { return h[i].f < h[j].f }
func (h openHeap) Swap(i, j int) {
    h[i], h[j] = h[j], h[i]
    h[i].fx = i
    h[j].fx = j
}

func (p *openHeap) Push(x interface{}) {
    h := *p
    fx := len(h)
    h = append(h, x.(*rNode))
    h[fx].fx = fx
    *p = h
}

func (p *openHeap) Pop() interface{} {
    h := *p
    last := len(h) - 1
    *p = h[:last]
    h[last].fx = -1
    return h[last]
}
