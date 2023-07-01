package main

import (
	"container/heap"
	"fmt"
)

// A PriorityQueue implements heap.Interface and holds Items.
type PriorityQueue struct {
	items []Vertex
	m     map[Vertex]int // value to index
	pr    map[Vertex]int // value to priority
}

func (pq *PriorityQueue) Len() int           { return len(pq.items) }
func (pq *PriorityQueue) Less(i, j int) bool { return pq.pr[pq.items[i]] < pq.pr[pq.items[j]] }
func (pq *PriorityQueue) Swap(i, j int) {
	pq.items[i], pq.items[j] = pq.items[j], pq.items[i]
	pq.m[pq.items[i]] = i
	pq.m[pq.items[j]] = j
}
func (pq *PriorityQueue) Push(x interface{}) {
	n := len(pq.items)
	item := x.(Vertex)
	pq.m[item] = n
	pq.items = append(pq.items, item)
}
func (pq *PriorityQueue) Pop() interface{} {
	old := pq.items
	n := len(old)
	item := old[n-1]
	pq.m[item] = -1
	pq.items = old[0 : n-1]
	return item
}

// update modifies the priority of an item in the queue.
func (pq *PriorityQueue) update(item Vertex, priority int) {
	pq.pr[item] = priority
	heap.Fix(pq, pq.m[item])
}
func (pq *PriorityQueue) addWithPriority(item Vertex, priority int) {
	heap.Push(pq, item)
	pq.update(item, priority)
}

const (
	Infinity      = int(^uint(0) >> 1)
	Uninitialized = -1
)

func Dijkstra(g Graph, source Vertex) (dist map[Vertex]int, prev map[Vertex]Vertex) {
	vs := g.Vertices()
	dist = make(map[Vertex]int, len(vs))
	prev = make(map[Vertex]Vertex, len(vs))
	sid := source
	dist[sid] = 0
	q := &PriorityQueue{
		items: make([]Vertex, 0, len(vs)),
		m:     make(map[Vertex]int, len(vs)),
		pr:    make(map[Vertex]int, len(vs)),
	}
	for _, v := range vs {
		if v != sid {
			dist[v] = Infinity
		}
		prev[v] = Uninitialized
		q.addWithPriority(v, dist[v])
	}
	for len(q.items) != 0 {
		u := heap.Pop(q).(Vertex)
		for _, v := range g.Neighbors(u) {
			alt := dist[u] + g.Weight(u, v)
			if alt < dist[v] {
				dist[v] = alt
				prev[v] = u
				q.update(v, alt)
			}
		}
	}
	return dist, prev
}

// A Graph is the interface implemented by graphs that
// this algorithm can run on.
type Graph interface {
	Vertices() []Vertex
	Neighbors(v Vertex) []Vertex
	Weight(u, v Vertex) int
}

// Nonnegative integer ID of vertex
type Vertex int

// sg is a graph of strings that satisfies the Graph interface.
type sg struct {
	ids   map[string]Vertex
	names map[Vertex]string
	edges map[Vertex]map[Vertex]int
}

func newsg(ids map[string]Vertex) sg {
	g := sg{ids: ids}
	g.names = make(map[Vertex]string, len(ids))
	for k, v := range ids {
		g.names[v] = k
	}
	g.edges = make(map[Vertex]map[Vertex]int)
	return g
}
func (g sg) edge(u, v string, w int) {
	if _, ok := g.edges[g.ids[u]]; !ok {
		g.edges[g.ids[u]] = make(map[Vertex]int)
	}
	g.edges[g.ids[u]][g.ids[v]] = w
}
func (g sg) path(v Vertex, prev map[Vertex]Vertex) (s string) {
	s = g.names[v]
	for prev[v] >= 0 {
		v = prev[v]
		s = g.names[v] + s
	}
	return s
}
func (g sg) Vertices() []Vertex {
	vs := make([]Vertex, 0, len(g.ids))
	for _, v := range g.ids {
		vs = append(vs, v)
	}
	return vs
}
func (g sg) Neighbors(u Vertex) []Vertex {
	vs := make([]Vertex, 0, len(g.edges[u]))
	for v := range g.edges[u] {
		vs = append(vs, v)
	}
	return vs
}
func (g sg) Weight(u, v Vertex) int { return g.edges[u][v] }

func main() {
	g := newsg(map[string]Vertex{
		"a": 1,
		"b": 2,
		"c": 3,
		"d": 4,
		"e": 5,
		"f": 6,
	})
	g.edge("a", "b", 7)
	g.edge("a", "c", 9)
	g.edge("a", "f", 14)
	g.edge("b", "c", 10)
	g.edge("b", "d", 15)
	g.edge("c", "d", 11)
	g.edge("c", "f", 2)
	g.edge("d", "e", 6)
	g.edge("e", "f", 9)

	dist, prev := Dijkstra(g, g.ids["a"])
	fmt.Printf("Distance to %s: %d, Path: %s\n", "e", dist[g.ids["e"]], g.path(g.ids["e"], prev))
	fmt.Printf("Distance to %s: %d, Path: %s\n", "f", dist[g.ids["f"]], g.path(g.ids["f"], prev))
}
