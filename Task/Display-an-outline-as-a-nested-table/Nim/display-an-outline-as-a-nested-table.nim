import strutils

const Outline = """Display an outline as a nested table.
    Parse the outline to a tree,
        measuring the indent of each line,
        translating the indentation to a nested structure,
        and padding the tree to even depth.
    count the leaves descending from each node,
        defining the width of a leaf as 1,
        and the width of a parent node as a sum.
            (The sum of the widths of its children)
    and write out a table with 'colspan' values
        either as a wiki table,
        or as HTML."""

type Color {.pure.} = enum
  NoColor
  Yellow = "#ffffe6;"
  Orange = "#ffebd2;"
  Green = "#f0fff0;"
  Blue = "#e6ffff;"

const Line1Color = Yellow
const Line2Colors = [Orange, Green, Blue]

type Node = ref object
  value: string
  level: Natural
  width: Natural
  color: Color
  parent: Node
  children: seq[Node]

#---------------------------------------------------------------------------------------------------

proc leadingSpaces(line: string): int =
  ## return the number of leading spaces.
  while line[result] == ' ':
    inc result

#---------------------------------------------------------------------------------------------------

proc buildTree(outline: string): tuple[root: Node, depth: Natural] =
  ## Build the tree for the given outline.

  result.root = Node()
  var level: int
  var startPos = @[-1]
  var nodes: seq[Node] = @[result.root]
  var linecount = 0

  for line in Outline.splitLines:
    inc linecount
    if line.len == 0: continue
    let start = line.leadingSpaces()
    level = startPos.find(start)

    if level < 0:
      # Level not yet encountered.
      if start < startPos[^1]:
        raise newException(ValueError, "wrong indentation at line " & $linecount)
      startPos.add(start)
      nodes.add(nil)
      level = startPos.high

    # Create the node.
    let node = Node(value: line.strip(), level: level)
    let parent = nodes[level - 1]
    parent.children.add(node)
    node.parent = parent
    nodes[level] = node   # Set the node as current node for this level.

  result.depth = nodes.high

#---------------------------------------------------------------------------------------------------

proc padTree(node: Node; depth: Natural) =
  ## pad the tree with empty nodes to get an even depth.
  if node.level == depth:
    return
  if node.children.len == 0:
    # Add an empty node.
    node.children.add(Node(level: node.level + 1, parent: node))
  for child in node.children:
    child.padTree(depth)

#---------------------------------------------------------------------------------------------------

proc computeWidths(node: Node) =
  ## Compute the widths.
  var width = 0
  if node.children.len == 0:
    width = 1
  else:
    for child in node.children:
      child.computeWidths()
      inc width, child.width
  node.width = width

#---------------------------------------------------------------------------------------------------

proc build(nodelists: var seq[seq[Node]]; node: Node) =
  ## Build the list of nodes per level.
  nodelists[node.level].add(node)
  for child in node.children:
    nodelists.build(child)

#---------------------------------------------------------------------------------------------------

proc setColors(nodelists: seq[seq[Node]]) =
  ## Set the colors of the nodes.
  for node in nodelists[1]:
    node.color = Line1Color
  for i, node in nodelists[2]:
    node.color = Line2Colors[i mod Line2Colors.len]
  for level in 3..nodelists.high:
    for node in nodelists[level]:
      node.color = if node.value.len != 0: node.parent.color else: NoColor

#---------------------------------------------------------------------------------------------------

proc writeWikiTable(nodelists: seq[seq[Node]]) =
  ## Output the wikitable.
  echo "{| class='wikitable' style='text-align: center;'"
  for level in 1..nodelists.high:
    echo "|-"
    for node in nodelists[level]:
      if node.width > 1:
        # Node with children.
        echo "| style='background: $1 ' colspan=$2 | $3".format(node.color, node.width, node.value)
      elif node.value.len > 0:
        # Leaf with contents.
        echo "| style='background: $1 ' | $2".format(node.color, node.value)
      else:
        # Empty cell.
        echo "|  | "
  echo "|}"

#---------------------------------------------------------------------------------------------------

proc writeHtml(nodelists: seq[seq[Node]]) =
  ## Output the HTML.
  echo "<table class='wikitable' style='text-align: center;'>"
  for level in 1..nodelists.high:
    echo "  <tr>"
    for node in nodelists[level]:
      if node.width > 1:
        # Node with children.
        echo "    <td colspan='$1' style='background-color: $2'>$3</td>".format(node.width, node.color, node.value)
      elif node.value.len > 0:
        # Leaf with contents.
        echo "    <td style='background-color: $1'>$2</td>".format(node.color, node.value)
      else:
        # Empty cell.
        echo "    <td></td>"
    echo "  </tr>"
  echo "</table>"

#———————————————————————————————————————————————————————————————————————————————————————————————————

let (root, depth) = Outline.buildTree()
root.padTree(depth)
root.computeWidths()
var nodelists = newSeq[seq[Node]](depth + 1)
nodelists.build(root)
nodelists.setColors()
echo "WikiTable:"
nodelists.writeWikiTable()
echo "HTML:"
nodelists.writeHtml()
