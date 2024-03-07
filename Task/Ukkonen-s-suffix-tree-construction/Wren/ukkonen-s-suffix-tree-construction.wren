import "./big" for BigRat
import "./dynamic" for Struct
import "./trait" for ByRef
import "io" for File

var maxChar = 128

var Node = Struct.create("Node", ["children", "suffixLink", "start", "pEnd", "suffixIndex"])

var text                 = ""
var root                 = null
var lastNewNode          = null
var activeNode           = null
var activeEdge           = -1
var activeLength         = 0
var remainingSuffixCount = 0
var pLeafEnd             = ByRef.new(-1)
var pRootEnd             = null
var pSplitEnd            = null
var size                 = -1

var newNode = Fn.new { |start, pEnd|
    var children = List.filled(maxChar, null)
    var suffixLink = root
    var suffixIndex = -1
    return Node.new(children, suffixLink, start, pEnd, suffixIndex)
}

var edgeLength = Fn.new { |n|
    if (n == root) return 0
    return n.pEnd.value - n.start + 1
}

var walkDown = Fn.new { |currNode|
    var el = edgeLength.call(currNode)
    if (activeLength >= el) {
        activeEdge = activeEdge + el
        activeLength = activeLength - el
        activeNode = currNode
        return true
    }
    return false
}

var extendSuffixTree = Fn.new { |pos|
    pLeafEnd.value = pos
    remainingSuffixCount = remainingSuffixCount + 1
    lastNewNode = null
    while (remainingSuffixCount > 0) {
        if (activeLength == 0) activeEdge = pos
        if (!activeNode.children[text[activeEdge].bytes[0]]) {
            activeNode.children[text[activeEdge].bytes[0]] = newNode.call(pos, pLeafEnd)
            if (lastNewNode) {
                lastNewNode.suffixLink = activeNode
                lastNewNode = null
            }
        } else {
            var next = activeNode.children[text[activeEdge].bytes[0]]
            if (walkDown.call(next)) continue
            if (text[next.start + activeLength] == text[pos]) {
                if (lastNewNode && activeNode != root) {
                    lastNewNode.suffixLink = activeNode
                    lastNewNode = null
                }
                activeLength = activeLength + 1
                break
            }
            var temp = next.start + activeLength - 1
            pSplitEnd = ByRef.new(temp)
            var split = newNode.call(next.start, pSplitEnd)
            activeNode.children[text[activeEdge].bytes[0]] = split
            split.children[text[pos].bytes[0]] = newNode.call(pos, pLeafEnd)
            next.start = next.start + activeLength
            split.children[text[next.start].bytes[0]] = next
            if (lastNewNode) lastNewNode.suffixLink = split
            lastNewNode = split
        }
        remainingSuffixCount = remainingSuffixCount - 1
        if (activeNode == root && activeLength > 0) {
            activeLength = activeLength - 1
            activeEdge = pos - remainingSuffixCount + 1
        } else if (activeNode != root) {
            activeNode = activeNode.suffixLink
        }
    }
}

var setSuffixIndexByDFS  // recursive
setSuffixIndexByDFS = Fn.new { |n, labelHeight|
    if (!n) return
    if (n.start != -1) {
        // Uncomment line below to print suffix tree
        // System.write(text[n.start..n.pEnd.value])
    }
    var leaf = 1
    for (i in 0...maxChar) {
        if (n.children[i]) {
            // Uncomment the 3 lines below to print suffix index
            // if (leaf == 1 && n.start != -1) {
            //    System.print(" [%(n.suffixIndex)]")
            // }
            leaf = 0
            setSuffixIndexByDFS.call(n.children[i], labelHeight + edgeLength.call(n.children[i]))
        }
    }
    if (leaf == 1) {
        n.suffixIndex = size - labelHeight
        // Uncomment line below to print suffix index
        // System.print(" [%(n.suffixIndex)]")
    }
}

var buildSuffixTree = Fn.new {
    size = text.count
    var temp = -1
    pRootEnd = ByRef.new(temp)
    root = newNode.call(-1, pRootEnd)
    activeNode = root
    for (i in 0...size) extendSuffixTree.call(i)
    var labelHeight = 0
    setSuffixIndexByDFS.call(root, labelHeight)
}

var doTraversal  // recursive
doTraversal = Fn.new { |n, labelHeight, pMaxHeight, pSubstringStartIndex|
    if (!n) return
    if (n.suffixIndex == -1) {
        for (i in 0...maxChar) {
            if (n.children[i]) {
                doTraversal.call(n.children[i], labelHeight + edgeLength.call(n.children[i]),
                    pMaxHeight, pSubstringStartIndex)
             }
        }
    } else if (n.suffixIndex > -1 && (pMaxHeight.value < labelHeight - edgeLength.call(n))) {
        pMaxHeight.value = labelHeight - edgeLength.call(n)
        pSubstringStartIndex.value = n.suffixIndex
    }
}

var getLongestRepeatedSubstring = Fn.new { |s|
    var maxHeight = 0
    var substringStartIndex = 0
    var pMaxHeight = ByRef.new(maxHeight)
    var pSubstringStartIndex = ByRef.new(substringStartIndex)
    doTraversal.call(root, 0, pMaxHeight, pSubstringStartIndex)
    maxHeight = pMaxHeight.value
    substringStartIndex = pSubstringStartIndex.value
    // Uncomment line below to print maxHeight and substringStartIndex
    // System.print("maxHeight %(maxHeight), substringStartIndex %(substringStartIndex)")
    if (s == "") {
        System.write("  %(text) is: ")
    } else {
        System.write("  %(s) is: ")
    }
    var k = 0
    while (k < maxHeight) {
        System.write(text[k + substringStartIndex])
        k = k + 1
    }
    if (k == 0) {
        System.write("No repeated substring")
    }
    System.print()
}

var tests = [
    "GEEKSFORGEEKS$",
    "AAAAAAAAAA$",
    "ABCDEFG$",
    "ABABABA$",
    "ATCGATCGA$",
    "banana$",
    "abcpqrabpqpq$",
    "pqrpqpqabab$",
]
System.print("Longest Repeated Substring in:\n")
for (test in tests) {
    text = test
    buildSuffixTree.call()
    getLongestRepeatedSubstring.call("")
}
System.print()

// load pi to 100,182 digits
var piStr = File.read("pi_100000.txt")
piStr = piStr[2..-1] // remove initial 3.
var numbers = [1e3, 1e4, 1e5]
maxChar = 58
for (number in numbers) {
    var start = System.clock
    text = piStr[0...number] + "$"
    buildSuffixTree.call()
    getLongestRepeatedSubstring.call("first %(number) d.p. of Pi")
    var elapsed = (System.clock - start) * 1000
    System.print("  (this took %(elapsed) ms)\n")
}
