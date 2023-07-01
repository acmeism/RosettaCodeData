import std/[sequtils, strformat, strutils, tables]

const ∞ = int.high

type

  # Suffix-tree node.
  Node = ref object
    children: Table[char, int]
    first: int
    last: int
    suffixLink: int
    suffixIndex: int

  # Ukkonen suffix-tree.
  SuffixTree = object
    nodes: seq[Node]
    text: string
    root: int
    position: int
    currentNode: int
    needSuffixLink: int
    remainder: int
    activeNode: int
    activeLength: int
    activeEdge: int


func newNode(): Node =
  Node(first: -1, last: ∞, suffixLink: -1, suffixIndex: -1)

func newNode(first, last: int): Node =
  Node(first: first, last: last, suffixLink: 0, suffixIndex: -1)

func newNode(st: var SuffixTree; first, last: int): int =
  inc st.currentNode
  st.nodes[st.currentNode] = newNode(first, last)
  result = st.currentNode


func activeEdgeChar(st: SuffixTree): char {.inline.} = st.text[st.activeedge]


func edgeLength(st: SuffixTree; n: Node): int =
  min(n.last, st.position + 1) - n.first


func addSuffixLink(st: var SuffixTree; nodenum: int) =
  if st.needSuffixLink >= 0:
    st.nodes[st.needSuffixLink].suffixLink = nodenum
  st.needSuffixLink = nodenum

func walkdown(st: var SuffixTree; currNode: int): bool =
  let length = st.edgeLength(st.nodes[currNode])
  if st.activeLength < length: return false
  inc st.activeEdge, length
  dec st.activeLength, length
  st.activeNode = currnode
  result = true


func extendSuffixTree(st: var SuffixTree; pos: int) =
  st.position = pos
  st.needSuffixLink = -1
  inc st.remainder
  while st.remainder > 0:
    if st.activeLength == 0: st.activeEdge = st.position
    if st.activeEdgeChar() notin st.nodes[st.activeNode].children:
      let nodeNum = st.newNode(st.position, ∞)
      st.nodes[st.activeNode].children[st.activeEdgeChar()] = nodeNum
      st.addSuffixLink(st.activeNode)
    else:
      let next = st.nodes[st.activeNode].children[st.activeEdgeChar()]
      if st.walkdown(next): continue
      if st.text[st.nodes[next].first + st.activeLength] == st.text[pos]:
        st.addSuffixLink(st.activeNode)
        inc st.activeLength
        break
      let split = st.newNode(st.nodes[next].first, st.nodes[next].first + st.activeLength)
      st.nodes[st.activeNode].children[st.activeEdgeChar()] = split
      let nodeNum = st.newNode(st.position, ∞)
      st.nodes[split].children[st.text[pos]] = nodeNum
      st.nodes[next].first += st.activelength
      st.nodes[split].children[st.text[st.nodes[next].first]] = next
      st.addSuffixLink(split)

    dec st.remainder
    if st.activeNode == st.root and st.activeLength > 0:
      dec st.activelength
      st.activeEdge = st.position - st.remainder + 1
    elif st.activeNode != st.root:
      st.activeNode = st.nodes[st.activeNode].suffixLink


proc setSuffixIndexByDFS(st: var SuffixTree; node: Node; labelHeight: Natural; verbose = false) =
  if verbose and node.first >= 0:
    echo st.text[node.first..<min(node.last, st.text.len)]
  var isLeaf = true
  for ichild in node.children.values:
    let child = st.nodes[ichild]
    if verbose and isLeaf and node.first >= 0:
      echo &" [{node.suffixindex}]"
    isLeaf = false
    st.setSuffixIndexbyDFS(child, labelHeight + st.edgeLength(child))
  if isleaf:
    node.suffixindex = st.text.len - labelHeight
    if verbose: echo &" [{node.suffixindex}]"

proc initSuffixTree(str: string): SuffixTree =
  var nodes = newSeqWith(str.len * 2, newNode())
  result = SuffixTree(nodes: nodes, text: str, position: -1, currentNode: -1,
                      needSuffixLink: -1, remainder: 0, activeLength: 1, activeEdge: 0)
  result.root = result.newNode(0, 0)
  result.activeNode = result.root
  for i in 0..result.text.high:
    result.extendSuffixTree(i)
  result.setSuffixIndexByDFS(result.nodes[result.root], 0)


func doTraversal(st: SuffixTree): (int, seq[int]) =
  var maxHeight = 0
  var substringStartIndices = @[-1]

  func traversal(node: Node; labelHeight: int) =
    if node.suffixIndex == -1:
      for ichild in node.children.values:
        let child = st.nodes[ichild]
        traversal(child, labelHeight + st.edgeLength(child))
    elif maxHeight < labelHeight - st.edgeLength(node):
      maxHeight = labelHeight - st.edgeLength(node)
      substringStartIndices = @[node.suffixIndex]
    elif maxHeight == labelHeight - st.edgelength(node):
      substringStartIndices.add node.suffixIndex

  traversal(st.nodes[st.root], 0)
  result = (maxHeight, move(substringStartIndices))


proc getLongestRepeatedSubstring(st: SuffixTree; label = ""; printResult = true): string =
  let (length, starts) = st.dotraversal()
  result = if length == 0: ""
           else: starts.mapIt(st.text[it..it+length-1]).deduplicate().join(" (or) ")
  if printResult:
    stdout.write "  ", if label.len == 0: join(st.text) else: label, ": "
    echo if length == 0: "No repeated substring." else: result



const Tests = ["CAAAABAAAABD$",
                "GEEKSFORGEEKS$",
                "AAAAAAAAAA$",
                "ABCDEFG$",
                "ABABABA$",
                "ATCGATCGA$",
                "banana$",
                "abcpqrabpqpq$",
                "pqrpqpqabab$"]

echo "Longest Repeated Substring in:\n"
for test in Tests:
  var st = initSuffixTree(test)
  discard st.getLongestRepeatedSubstring()
echo()


#############################################################################
# Pi calculation.

import std/[monotimes, times]
import integers

func isr(term, guess: Integer): Integer =
  var term = term
  result = guess
  let value = term * result
  while true:
    if abs(term - result) <= 1:
      break
    result = (result + term) shr 1
    term = value div result

func calcAgm(lam, gm: Integer; z: var Integer; ep: Integer): Integer =
  var am: Integer
  var lam = lam
  var gm = gm
  var n = 1
  while true:
    am = (lam + gm) shr 1
    gm = isr(lam, gm)
    let v = am - lam
    let zi = v * v * n
    if zi < ep:
      break
    z -= zi
    inc n, n
    lam = am
  result = am

func bip(exp: int; man = 1): Integer {.inline.} = man * 10^exp

func calculatePi(): string =
  const Digits = 4_000_000
  let am = bip(Digits)
  let gm = isqrt(bip(Digits + Digits - 1, 5))
  var z = bip(Digits + Digits - 2, 25)
  let agm = calcAGM(am, gm, z, bip(Digits + 1))
  let pi = agm * agm * bip(Digits - 2) div z
  result = $pi

let sπ = calculatePi()
for number in [1000, 10000, 100000, 1000000]:
  let text = sπ[2..<number] & '$'
  let start = getMonoTime()
  var st = initSuffixTree(text)
  discard st.getlongestrepeatedsubstring(&"first {number} d.p. of π")
  echo &"  → Temps: {(getMonoTime() - start).inMicroseconds} µs"
