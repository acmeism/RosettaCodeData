# (*) If using gojq, uncomment the following line:
# def keys_unsorted: keys;

# remove the first occurrence of $x from the input array
def rm($x):
  index($x) as $ix
  | if $ix then .[:$ix] + .[$ix+1:] else . end;

# Input: a Graph
# Output: a (possibly empty) stream of the neighbors of $node
# that are also in the array $ary
def neighbors($node; $ary:
  .[$node]
  | select(.)
  | keys_unsorted[]
  | . as $n
  | select($ary | index($n));

# Input: a Graph
def vertices:
  [keys_unsorted[], (.[] | keys_unsorted[])] | unique;

# Input: a Graph
# Output: the final version of the scratchpad
def dijkstra($startname):
  . as $graph
  | vertices as $Q
  # scratchpad: { node: { prev, dist} }
  | reduce $Q[] as $v ({};
      . + { ($v): {prev: null, dist: infinite}} )
  | .[$startname].dist = 0
  | { scratchpad: ., $Q }
  | until( .Q|length == 0;
      .scratchpad as $scratchpad
      | ( .Q | min_by($scratchpad[.].dist)) as $u
      | .Q |= rm($u)
      | .Q as $Q
      # for each neighbor v of u still in Q:
      | reduce ($graph|neighbors($u; $Q)) as $v (.;
              (.scratchpad[$u].dist + $graph[$u][$v]) as $alt
              | if $alt < .scratchpad[$v].dist
                then .scratchpad[$v].dist = $alt
                | .scratchpad[$v].prev = $u
		else . end ) )
  | .scratchpad ;	

# Input: a Graph
# Output: the scratchpad
def Dijkstra($startname):
  if .[$startname] == null then "The graph does not contain start vertex \(startname)"
  else dijkstra($startname)
  end;

# Input: scratchpad, i.e. a dictionary with key:value pairs of the form:
#   node: {prev, dist}
# Output: an array, being
#   [optimal path from $node to $n, optimal distance from $node to $n]
def readout($node):
  . as $in
  | $node
  | [recurse($in[.].prev; .)]
  | [reverse, $in[$node].dist] ;

# Input: a graph
# Output: [path, value]
def Dijkstra($startname; $endname):
  Dijkstra($startname)
  | readout($endname) ;
