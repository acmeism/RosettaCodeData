# Emit a stream of first occurrences of items in the stream
def firsts(stream):
  foreach stream as $x (null;
     ($x|tostring) as $s
     | if . == null or .[$s] == null then .[$s] = $x | .emit = $x
       elif .[$s] then .emit = null
       else .emit = null
       end;
     select(.emit).emit);

# {numVertices, vertices, adjacency }
def Graph($edges):
  # Use `reverse` to ensure the ordering of independents is respected
  ([firsts($edges | keys_unsorted[], .[][])] | reverse) as $vertices
  | ($vertices|length) as $nv
  | reduce ($edges | keys_unsorted[]) as $k ({};
      reduce ($edges[$k][]) as $v (.;
         if $k == $v then . # ignore self-dependencies
         else .[$k][$v] = true
         end ) )
  | {$vertices, numVertices: $nv, adjacency: .} ;

# Input: a Graph
def topLevels:
  .result = []
  # look for empty columns
  | reduce .vertices[] as $c (.;
       .outer = false
       | .r = 0
       | until(.outer or .r == .numVertices;
            if .adjacency[.vertices[.r]][$c]
            then .outer = true
            end
            | .r += 1 )
       | if .outer == false then .result += [$c] end
     )
  | .result;

# Input: a Graph
def compileOrder($item):
  . + {result: [], queue: [$item] }
  | until (.queue | length == 0;
         .queue[0] as $r
         | .queue |= .[1:]
         # Ignore cycles by subtracting .result:
         | reduce (.vertices - .result)[] as $c (.;
             if .adjacency[$r][$c] and (.queue|index($c) == null)
             then .queue += [$c]
             end )
         | .result = [$r] + .result
        )
  | [firsts(.result[])];

### An example

def deps: {
   "top1" : ["ip1", "des1", "ip2"],
   "top2" : ["ip2", "des1", "ip3"],
   "des1" : ["des1a", "des1b", "des1c"],
   "des1a": ["des1a1", "des1a2"],
   "des1c": ["des1c1", "extra1"],
   "ip2"  : ["ip2a", "ip2b", "ip2c", "ipcommon"],
   "ip1"  : ["ip1a", "ipcommon", "extra1"]
   };

def files: ["top1", "top2", "ip1"];

Graph(deps)
| "Top levels: \(topLevels)",
   (files[] as $f
    | "\nA compilation order for \($f):",
      (compileOrder($f)|join(" ")) )

