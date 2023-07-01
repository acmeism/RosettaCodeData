# Fill an array of the specified length with the input value
def dimension($n): . as $in | [range(0;$n) | $in];

# $graph should be an adjacency-list graph with IO==0
def korasaju($graph):
  ($graph|length) as $length
  | def init: {
        vis: (false | dimension($length)),  # visited
        L: [],                              # for an array of $length integers
        t: ([]|dimension($length)),         # transposed graph
        x: $length                          # index
      };

    # input: {vis, L, t, x, t}
    def visit($u):
      if .vis[$u] | not
      then .vis[$u] = true
      |  reduce ($graph[$u][]) as $v (.;
              visit($v)
              | .t[$v] += [$u] )
      | .x -= 1
      | .L[.x] = $u
      else .
      end ;

    # input: {vis, t, c}
    def assign($u; $root):
      if .vis[$u]
      then .vis[$u] = false
      | .c[$u] = $root
      | reduce .t[$u][] as $v (.; assign($v; $root))
      else .
      end ;

    # For each vertex u of the graph, mark u as unvisited.
    init

    # For each vertex u of the graph do visit(u)
    | reduce range(0;$length) as $u (.; visit($u))
    | .c = (null|dimension($length))

    # For each element u of L in order, do assign(u, u)
    | reduce .L[] as $u (.; assign($u; $u) )
    | .c ;

# An example adjacency list using IO==1
def g: [
    [1],
    [2],
    [0],
    [1, 2, 4],
    [3, 5],
    [2, 6],
    [5],
    [4, 6, 7]
];

korasaju(g)
