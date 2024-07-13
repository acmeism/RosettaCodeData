# Add a single edge assuming it is not already there
# Input: a JSON object with at least the key .start
def addEdge($n1; $n2):
  # adjust to starting node number
  ($n1 - .start) as $n1
  | ($n2 - .start) as $n2
  | .nbr[$n1] += [$n2]
  | if $n1 != $n2 then .nbr[$n2] += [$n1] end ;

# Build a Graph object from $start and $edges assuming there are no isolated edges
def Graph($start; $edges):
  ([$edges[][]] | unique | length) as $nns
  | {$start,                    # node numbering starts from $start
     $nns,                      # number of nodes
     $edges,                    # array of edges
     nbr: [range(0;$nns) | [] ] # .nbr[$i] will be the array of neighbors of node $i
    }
  | reduce $edges[] as $e (.; addEdge($e[0]; $e[1]));

# Use greedy algorithm
def greedyColoring:
  # create a list with a color for each node
  .cols = [range(0; .nns) | -1] # -1 denotes no color assigned
  | .cols[0] = 0               # first node assigned color 0
  # create a bool list to keep track of which colors are available
  | .available = [range(0; .nns) | false]
  # assign colors to all nodes after the first
  | reduce range(1; .nns) as $i (.;
      # iterate through neighbors and mark their colors as available
      reduce .nbr[$i][] as $j (.;
          if .cols[$j] != -1 then .available[.cols[$j]] = true end )
      # find the first available color
      | (.available | index(false)) as $c
      | if $c
        then .cols[$i] = $c  # assign it to the current node
        # reset the colors of the neighbors to unavailable
        # before the next iteration
        | reduce .nbr[$i][] as $j (.;
            if (.cols[$j] != -1) then .available[.cols[$j]] = false end )
        else debug("greedyColoring unexpectedly did not find 'false'")
        end )
  | .cols;

# (n)umber of node and its (v)alence i.e. number of neighbors
def NodeVal($n; $v): {$n, $v};


### Example graphs

def Graph1:
  {start: 0,
   edges: [[0, 1], [1, 2], [2, 0], [3, 3]]} ;

def Graph2:
  {start: 1,
   edges:
     [[1, 6], [1, 7], [1, 8], [2, 5], [2, 7], [2, 8],
      [3, 5], [3, 6], [3, 8], [4, 5], [4, 6], [4, 7]] };

def Graph3:
  {start: 1,
   edges:
     [[1, 4], [1, 6], [1, 8], [3, 2], [3, 6], [3, 8],
      [5, 2], [5, 4], [5, 8], [7, 2], [7, 4], [7, 6]] };

def Graph4:
  {start: 1,
   edges:
    [[1, 6], [7, 1], [8, 1], [5, 2], [2, 7], [2, 8],
     [3, 5], [6, 3], [3, 8], [4, 5], [4, 6], [4, 7]] };

# Use `Function` to find a coloring for each of the examples given as an array:
def task(Function):
  . as $examples
  | length as $n
  | range(0; $n) as $i
  | $examples[$i] as $g
  | "\nExample \($i+1)",
     ( $g
       | Graph( .start; .edges )
       | Function as $cols
       | .ecount = 0  # counts edges
       | .emit = null
       | reduce .edges[] as $e (.;
           if ($e[0] != $e[1])
           then .emit += "    Edge  \($e[0])-\($e[1]) -> Color \($cols[$e[0] - .start]), \($cols[$e[1] - .start])\n"
           | .ecount += 1
           else .emit += "    Node  \($e[0])   -> Color \($cols[$e[0] - .start])\n"
           end)
       | .emit,
         (reduce $cols[] as $col (.maxCol = 0;  # maximum color number used
            if ($col > .maxCol) then .maxCol = $col end)
          |
           "    Number of nodes  : \(.nns)",
           "    Number of edges  : \(.ecount)",
           "    Number of colors : \(.maxCol+1)"
          ) ) ;

"Using the greedyColoring algorithm",
([Graph1, Graph2, Graph3, Graph4] | task(greedyColoring))
