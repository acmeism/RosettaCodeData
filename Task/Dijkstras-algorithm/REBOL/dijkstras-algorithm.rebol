Rebol [
    title: "Rosetta code: Dijkstra's algorithm"
    file:  %Dijkstra's_algorithm.r3
    url:   https://rosettacode.org/wiki/Dijkstra's_algorithm
]

make-graph: function [
    "Build adjacency map from an edge list of [src dst cost] blocks."
    edges [block!]
][
    neighbours: make map! []
    foreach [src dst cost] edges [
        unless neighbours/:src [neighbours/:src: make block! 4]
        repend neighbours/:src [dst cost]
    ]
    neighbours
]

dijkstra: function [
    "Find lowest-cost path between first and last in graph."
    graph  [map!]
    first  [any-type!]
    last   [any-type!]
][
    ;; collect all vertices from the adjacency map
    vertices: make block! 16
    foreach [src neighbours] graph [
        append vertices src
        foreach [dst cost] neighbours [append vertices dst]
    ]
    vertices: unique vertices

    ;; initialise distances to infinity, zero for start vertex
    dist:     make map! []
    previous: make map! []
    not-seen: copy vertices
    foreach v vertices [dist/:v: 1.#inf]
    dist/:first: 0

    while [not empty? not-seen] [
        ;; pick unvisited vertex with smallest tentative distance
        vertex1: none
        mindist: 1.#inf
        foreach v not-seen [
            if dist/:v < mindist [vertex1: v  mindist: dist/:v]
        ]
        if any [none? vertex1  vertex1 = last] [break]
        remove find not-seen vertex1

        ;; relax edges to neighbours
        foreach [vertex2 cost] any [graph/:vertex1 []] [
            if find not-seen vertex2 [
                altdist: dist/:vertex1 + cost
                if altdist < dist/:vertex2 [
                    ;; vertex1 is best predecessor of vertex2
                    dist/:vertex2:     altdist
                    previous/:vertex2: vertex1
                ]
            ]
        ]
    ]

    ;; reconstruct path by walking predecessors back from last to first
    path: make block! 8
    vertex: last
    while [vertex] [
        append path vertex
        vertex: previous/:vertex
    ]
    reverse path
]

print-path: function [
    "Print a path as:  first → ... → last"
    path [block!]
][
    buf: to string! path/1
    foreach vertex next path [append append buf " -> " vertex]
    print [
        "Shortest path from" path/1 "to" last path ":"
        buf
    ]
]

graph: make-graph [
    a b  7   a c  9   a f 14
    b c 10   b d 15   c d 11
    c f  2   d e  6   e f  9
]
?? graph
print-path dijkstra graph 'a 'e
print-path dijkstra graph 'a 'f
