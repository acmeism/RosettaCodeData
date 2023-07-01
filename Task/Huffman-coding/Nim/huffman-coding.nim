import tables, sequtils

type

  # Following range can be changed to produce Huffman codes on arbitrary alphabet (e.g. ternary codes)
  CodeSymbol = range[0..1]

  HuffCode = seq[CodeSymbol]

  Node = ref object
    f: int
    parent: Node
    case isLeaf: bool
    of true:
      c: char
    else:
      childs: array[CodeSymbol, Node]

func `<`(a: Node, b: Node): bool =
  # For min operator.
  a.f < b.f

func `$`(hc: HuffCode): string =
  result = ""
  for symbol in hc:
    result &= $symbol

func freeChildList(tree: seq[Node], parent: Node = nil): seq[Node] =
  ## Constructs a sequence of nodes which can be adopted
  ## Optional parent parameter can be set to ensure node will not adopt itself
  for node in tree:
    if node.parent.isNil and node != parent: result.add(node)

func connect(parent: Node, child: Node) =
  # Only call this proc when sure that parent has a free child slot
  child.parent = parent
  parent.f += child.f
  for i in parent.childs.low..parent.childs.high:
    if parent.childs[i] == nil:
      parent.childs[i] = child
      return

func generateCodes(codes: TableRef[char, HuffCode],
                   currentNode: Node, currentCode: HuffCode = @[]) =

  if currentNode.isLeaf:
    let key = currentNode.c
    codes[key] = currentCode
    return

  for i in currentNode.childs.low..currentNode.childs.high:
    if not currentNode.childs[i].isNil:
      let newCode = currentCode & i
      generateCodes(codes, currentNode.childs[i], newCode)


func buildTree(frequencies: CountTable[char]): seq[Node] =

  result = newSeq[Node](frequencies.len)
  for i in result.low..result.high:
    let key = toSeq(frequencies.keys)[i]
    result[i] = Node(f: frequencies[key], isLeaf: true, c: key)

  while result.freeChildList.len > 1:
    let currentNode = new Node
    result.add(currentNode)
    for c in currentNode.childs:
      currentNode.connect(min(result.freeChildList(currentNode)))
      if result.freeChildList.len <= 1: break

when isMainModule:

  import algorithm, strformat

  const
    SampleString = "this is an example for huffman encoding"
    SampleFrequencies = SampleString.toCountTable()

  func `<`(code1, code2: HuffCode): bool =
    # Used to sort the result.
    if code1.len == code2.len:
      result = false
      for (c1, c2) in zip(code1, code2):
        if c1 != c2: return c1 < c2
    else:
      result = code1.len < code2.len

  let
    tree = buildTree(SampleFrequencies)
    root = tree.freeChildList[0]

  var huffCodes = newTable[char, HuffCode]()
  generateCodes(huffCodes, root)

  for (key, value) in sortedByIt(toSeq(huffCodes.pairs), it[1]):
    echo &"'{key}' → {value}"
