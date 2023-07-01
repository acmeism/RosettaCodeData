import algorithm, strformat, strutils, tables

type

  Node = ref object
    edges: Table[char, Node]  # Edges (forward links).
    link: Node                # Suffix link (backward link).
    len: int                  # Length of the node.

  Eertree = object
    nodes: seq[Node]
    rto: Node                 # Odd length root node or node -1.
    rte: Node                 # Even length root node or node 0.Node
    str: string               # Accumulated input string.
    maxSuf: Node              # Maximum suffix.

#---------------------------------------------------------------------------------------------------

func initEertree(): Eertree =
  ## Create and initialize an eertree.
  result = Eertree(rto: Node(len: - 1), rte: Node(len: 0))
  result.rto.link = result.rto
  result.rte.link = result.rto
  result.str = "0"
  result.maxSuf = result.rte

#---------------------------------------------------------------------------------------------------

func getMaxSuffixPal(tree: Eertree; startNode: Node; ch: char): Node =
  ## We traverse the suffix-palindromes of "tree" in the order of decreasing length.
  ## For each palindrome we read its length "k" and compare "tree[i-k]" against "ch"
  ## until we get an equality or arrive at the -1 node.

  result = startNode
  let i = tree.str.high
  while result != tree.rto and tree.str[i - result.len] != ch:
    doAssert(result != result.link, "circular reference above odd root")
    result = result.link

#---------------------------------------------------------------------------------------------------

func add(tree: var Eertree; ch: char): bool =
  ## We need to find the maximum suffix-palindrome P of Ta.
  ## Start by finding maximum suffix-palindrome Q of T.
  ## To do this, we traverse the suffix-palindromes of T
  ## in the order of decreasing length, starting with maxSuf(T).

  let q = tree.getMaxSuffixPal(tree.maxSuf, ch)

  # We check "q" to see whether it has an outgoing edge labeled by "ch".
  result = ch notin q.edges

  if result:
    # We create the node "p" of length "q.len + 2"
    let p = Node()
    tree.nodes.add(p)
    p.len = q.len + 2
    if p.len == 1:
      # If p = ch, create the suffix link (p, 0).
      p.link = tree.rte
    else:
      # It remains to create the suffix link from "p" if "|p|>1". Just continue
      # traversing suffix-palindromes of T starting with the suffix link of "q".
      p.link = tree.getMaxSuffixPal(q.link, ch).edges[ch]
    # Create the edge "(q, p)".
    q.edges[ch] = p

  # "p" becomes the new maxSuf.
  tree.maxSuf = q.edges[ch]

  # Store accumulated input string.
  tree.str.add(ch)

#---------------------------------------------------------------------------------------------------

func getSubPalindromes(tree: Eertree; node: Node;
                       nodesToHere: seq[Node]; charsToHere: string;
                       result: var seq[string]) =
  ## Each node represents a palindrome, which can be reconstructed
  ## by the path from the root node to each non-root node.

  # Traverse all edges, since they represent other palindromes.
  for linkName, node2 in node.edges.pairs:
    tree.getSubPalindromes(node2, nodesToHere & node2, charsToHere & linkName, result)

  # Reconstruct based on charsToHere characters.
  if node notin [tree.rto, tree.rte]:
    # Don’t print for root nodes.
    let assembled = reversed(charsTohere).join() &
                    (if nodesToHere[0] == tree.rte: charsToHere
                     else: charsToHere[1..^1])
    result.add(assembled)

#---------------------------------------------------------------------------------------------------

func getSubPalindromes(tree: Eertree): seq[string] =
  ## Traverse tree to find sub-palindromes.

  # Odd length words
  tree.getSubPalindromes(tree.rto, @[tree.rto], "", result)
  # Even length words
  tree.getSubPalindromes(tree.rte, @[tree.rte], "", result)

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:
  const Str = "eertree"
  echo fmt"Processing string: '{Str}'"
  var eertree = initEertree()
  for ch in Str:
    discard eertree.add(ch)
  echo fmt"Number of sub-palindromes: {eertree.nodes.len}"
  let result = eertree.getSubPalindromes()
  echo fmt"Sub-palindromes: {result.join("", "")}"
