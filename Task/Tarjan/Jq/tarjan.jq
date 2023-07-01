# Input: an integer
def Node:
  { n: .,
    index: -1,    # -1 signifies undefined
    lowLink: -1,
    onStack: false
  } ;

# Input: a DirectedGraph
# Output: a stream of Node ids
def successors($vn): .es[$vn][];

# Input: a DirectedGraph
# Output: an array of integer arrays
def tarjan:
  . + { sccs: [],    # strongly connected components
        index: 0,
        s: []        # Stack
      }
  # input: {es, vs, sccs, index, s}
  | def strongConnect($vn):
      # Set the depth index for v to the smallest unused index
        .vs[$vn].index = .index
      | .vs[$vn].lowLink = .index
      | .index += 1
      | .s += [ $vn ]
      | .vs[$vn].onStack = true

      # consider successors of v
      | reduce successors($vn) as $wn (.;
            if .vs[$wn].index < 0
	    then
                # Successor w has not yet been visited; recurse on it
                strongConnect($wn)
                | .vs[$vn].lowLink = ([.vs[$vn].lowLink, .vs[$wn].lowLink] | min )
            elif .vs[$wn].onStack
	    then
                # Successor w is in stack s and hence in the current SCC
                .vs[$vn].lowLink = ([.vs[$vn].lowLink, .vs[$wn].index] | min )
	    else .
            end
        )
      # If v is a root node, pop the stack and generate an SCC
      | if .vs[$vn] | (.lowLink == .index)
        then .scc = []
	    | .stop = false
            | until(.stop;
                .s[-1] as $wn
		| .s |= .[:-1]    # pop
                | .vs[$wn].onStack = false
                | .scc += [$wn]
                | if $wn == $vn then .stop = true else . end )
        | .sccs += [.scc]
        else .
	end
    ;

    reduce .vs[].n as $vn (.;
      if .vs[$vn].index < 0
      then strongConnect($vn)
      else . end
    )
    | .sccs
;

# Vertices
def vs: [range(0;8) | Node ];

# Edges
def es:
  [ [1],
    [2],
    [0],
    [1, 2, 4],
    [5, 3],
    [2, 6],
    [5],
    [4, 7, 6]
  ]
;

{ vs: vs, es: es }
| tarjan
