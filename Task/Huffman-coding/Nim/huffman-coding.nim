import tables, seqUtils

const sampleString = "this is an example for huffman encoding"

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

proc `<`(a: Node, b: Node): bool =
    # For min operator
    a.f < b.f

proc `$`(hc: HuffCode): string =
    result = ""
    for symbol in hc:
        result &= $symbol

proc freeChildList(tree: seq[Node], parent: Node = nil): seq[Node] =
    # Constructs a sequence of nodes which can be adopted
    # Optional parent parameter can be set to ensure node will not adopt itself
    result = @[]
    for node in tree:
        if node.parent == nil and node != parent:
            result.add(node)

proc connect(parent: Node, child: Node) =
    # Only call this proc when sure that parent has a free child slot
    child.parent = parent
    parent.f += child.f
    for i in parent.childs.low..parent.childs.high:
        if parent.childs[i] == nil:
            parent.childs[i] = child
            return

proc generateCodes(codes: TableRef[char, HuffCode], currentNode: Node, currentCode: HuffCode = @[]) =
    if currentNode.isLeaf:
        let key = currentNode.c
        codes[key] = currentCode
        return
    for i in currentNode.childs.low..currentNode.childs.high:
        if currentNode.childs[i] != nil:
            let newCode = currentCode & i
            generateCodes(codes, currentNode.childs[i], newCode)

proc buildTree(frequencies: CountTable[char]): seq[Node] =
    result = newSeq[Node](frequencies.len)
    for i in result.low..result.high:
        let key = toSeq(frequencies.keys)[i]
        result[i] = Node(f: frequencies[key], isLeaf: true, c: key)
    while result.freeChildList.len > 1:
        let currentNode = new Node
        result.add(currentNode)
        for c in currentNode.childs:
            currentNode.connect(min(result.freeChildList(currentNode)))
            if result.freeChildList.len <= 1:
                break

var sampleFrequencies = initCountTable[char]()
for c in sampleString:
    sampleFrequencies.inc(c)
let
    tree = buildTree(sampleFrequencies)
    root = tree.freeChildList[0]
var huffCodes = newTable[char, HuffCode]()
generateCodes(huffCodes, root)
echo huffCodes
