import "./queue" for PriorityQueue

class HuffmanTree {
    construct new(freq) {
        _freq = freq
    }
    freq { _freq }
    compareTo(tree) { _freq - tree.freq }
}

class HuffmanLeaf is HuffmanTree {
    construct new (freq, val) {
        super(freq)
        _val = val
    }
    val { _val }
}

class HuffmanNode is HuffmanTree {
    construct new(l, r) {
        super(l.freq + r.freq)
        _left = l
        _right = r
    }
    left  { _left }
    right { _right }
}

var buildTree = Fn.new { |charFreqs|
    var trees = PriorityQueue.new()
    var index = 0
    for (freq in charFreqs) {
        if (freq > 0) trees.push(HuffmanLeaf.new(freq, String.fromByte(index)), -freq)
        index = index + 1
    }
    if (trees.count == 0) Fiber.abort("Something went wrong!")
    while (trees.count > 1) {
        var a = trees.pop()
        var b = trees.pop()
        var h = HuffmanNode.new(a[0], b[0])
        trees.push(h, -h.freq)
    }
    return trees.pop()[0]
}

var printCodes // recursive
printCodes = Fn.new { |tree, prefix|
    if (tree is HuffmanLeaf) {
        System.print("%(tree.val)\t%(tree.freq)\t%(prefix)")
    } else if (tree is HuffmanNode) {
        // traverse left
        prefix = prefix + "0"
        printCodes.call(tree.left, prefix)
        prefix = prefix[0...-1]
        // traverse right
        prefix = prefix + "1"
        printCodes.call(tree.right, prefix)
        prefix = prefix[0...-1]
    }
}

var test = "this is an example for huffman encoding"

var freqs = List.filled(256, 0)
for (c in test) {
    var ix = c.bytes[0]
    freqs[ix] = freqs[ix] + 1
}

var tree = buildTree.call(freqs)
System.print("SYMBOL\tWEIGHT\tHUFFMAN CODE")
printCodes.call(tree, "")
