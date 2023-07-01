import algorithm, sequtils, strscans, strutils, tables

const NoColor = 0

type

  Color = range[0..63]

  Node = ref object
    num: Natural          # Node number.
    color: Color          # Node color.
    degree: Natural       # Node degree.
    dsat: Natural         # Node Dsaturation.
    neighbors: seq[Node]  # List of neighbors.

  Graph = seq[Node]       # List of nodes ordered by number.

#---------------------------------------------------------------------------------------------------

proc initGraph(graphRepr: string): Graph =
  ## Initialize the graph from its string representation.

  var mapping: Table[Natural, Node]   # Temporary mapping.
  for elem in graphRepr.splitWhitespace():
    var num1, num2: int
    if elem.scanf("$i-$i", num1, num2):
      let node1 = mapping.mgetOrPut(num1, Node(num: num1))
      let node2 = mapping.mgetOrPut(num2, Node(num: num2))
      node1.neighbors.add node2
      node2.neighbors.add node1
    elif elem.scanf("$i", num1):
      discard mapping.mgetOrPut(num1, Node(num: num1))
    else:
      raise newException(ValueError, "wrong description: " & elem)

  for node in mapping.values:
    node.degree = node.neighbors.len
  result = sortedByIt(toSeq(mapping.values), it.num)

#---------------------------------------------------------------------------------------------------

proc numbers(nodes: seq[Node]): string =
  ## Return the numbers of a list of nodes.
  for node in nodes:
    result.addSep(" ")
    result.add($node.num)

#---------------------------------------------------------------------------------------------------

proc `$`(graph: Graph): string =
  ## Return the description of the graph.

  var maxColor = NoColor
  for node in graph:
    stdout.write "Node ", node.num, ":   color = ", node.color
    if node.color > maxColor: maxColor = node.color
    if node.neighbors.len > 0:
      echo "   neighbors = ", sortedByIt(node.neighbors, it.num).numbers
    else:
      echo ""
  echo "Number of colors: ", maxColor

#---------------------------------------------------------------------------------------------------

proc `<`(node1, node2: Node): bool =
  ## Comparison of nodes, by dsaturation first, then by degree.
  if node1.dsat == node2.dsat: node1.degree < node2.degree
  else: node1.dsat < node2.dsat

#---------------------------------------------------------------------------------------------------

proc getMaxDsatNode(nodes: var seq[Node]): Node =
  ## Return the node with the greatest dsaturation.
  let idx = nodes.maxIndex()
  result = nodes[idx]
  nodes.delete(idx)

#---------------------------------------------------------------------------------------------------

proc minColor(node: Node): COLOR =
  ## Return the minimum available color for a node.
  var colorUsed: set[Color]
  for neighbor in node.neighbors:
    colorUsed.incl neighbor.color
  for color in 1..Color.high:
    if color notin colorUsed: return color

#---------------------------------------------------------------------------------------------------

proc distinctColorsCount(node: Node): Natural =
  ## Return the number of distinct colors of the neighbors of a node.
  var colorUsed: set[Color]
  for neighbor in node.neighbors:
    colorUsed.incl neighbor.color
  result = colorUsed.card

#---------------------------------------------------------------------------------------------------

proc updateDsats(node: Node) =
  ## Update the dsaturations of the neighbors of a node.
  for neighbor in node.neighbors:
    if neighbor.color == NoColor:
      neighbor.dsat = neighbor.distinctColorsCount()

#---------------------------------------------------------------------------------------------------

proc colorize(graphRepr: string) =
  ## Colorize a graph.

  let graph = initGraph(graphRepr)
  var nodes = sortedByIt(graph, -it.degree)   # Copy or graph sorted by decreasing degrees.
  while nodes.len > 0:
    let node = nodes.getMaxDsatNode()
    node.color = node.minColor()
    node.updateDsats()

  echo "Graph: ", graphRepr
  echo graph


#---------------------------------------------------------------------------------------------------

when isMainModule:
  colorize("0-1 1-2 2-0 3")
  colorize("1-6 1-7 1-8 2-5 2-7 2-8 3-5 3-6 3-8 4-5 4-6 4-7")
  colorize("1-4 1-6 1-8 3-2 3-6 3-8 5-2 5-4 5-8 7-2 7-4 7-6")
  colorize("1-6 7-1 8-1 5-2 2-7 2-8 3-5 6-3 3-8 4-5 4-6 4-7")
