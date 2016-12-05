enum HuffmanTree<T> {
  case Leaf(T)
  indirect case Node(HuffmanTree<T>, HuffmanTree<T>)

  func printCodes(prefix: String) {
    switch(self) {
    case let .Leaf(c):
      print("\(c)\t\(prefix)")
    case let .Node(l, r):
      l.printCodes(prefix + "0")
      r.printCodes(prefix + "1")
    }
  }
}

func buildTree<T>(freqs: [(T, Int)]) -> HuffmanTree<T> {
  assert(freqs.count > 0, "must contain at least one character")
  // leaves sorted by increasing frequency
  let leaves : [(Int, HuffmanTree<T>)] = freqs.sort { (p1, p2) in p1.1 < p2.1 }.map { (x, w) in (w, .Leaf(x)) }
  // nodes sorted by increasing frequency
  var nodes = [(Int, HuffmanTree<T>)]()
  // iterate through leaves and nodes in order of increasing frequency
  for var i = 0, j = 0; ; {
    assert(i < leaves.count || j < nodes.count)
    // get subtree of least frequency
    var e1 : (Int, HuffmanTree<T>)
    if j == nodes.count || i < leaves.count && leaves[i].0 < nodes[j].0 {
      e1 = leaves[i]
      i++
    } else {
      e1 = nodes[j]
      j++
    }

    // if there's no subtrees left, then that one was the answer
    if i == leaves.count && j == nodes.count {
      return e1.1
    }

    // get next subtree of least frequency
    var e2 : (Int, HuffmanTree<T>)
    if j == nodes.count || i < leaves.count && leaves[i].0 < nodes[j].0 {
      e2 = leaves[i]
      i++
    } else {
      e2 = nodes[j]
      j++
    }
    // create node from two subtrees
    nodes.append((e1.0 + e2.0, .Node(e1.1, e2.1)))
  }
}

func getFreqs<S : SequenceType where S.Generator.Element : Hashable>(seq: S) -> [(S.Generator.Element, Int)] {
  var freqs : [S.Generator.Element : Int] = [:]
  for c in seq {
    freqs[c] = (freqs[c] ?? 0) + 1
  }
  return Array(freqs)
}

let str = "this is an example for huffman encoding"
let charFreqs = getFreqs(str.characters)
let tree = buildTree(charFreqs)
print("Symbol\tHuffman code")
tree.printCodes("")
