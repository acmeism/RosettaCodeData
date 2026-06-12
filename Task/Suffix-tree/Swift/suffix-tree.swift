import Foundation

class SuffixTreeProblem {
    private class Node {
        var sub = ""                  // a substring of the input string
        var ch = [Int]()              // list of child nodes
    }

    private class SuffixTree {
        private var nodes = [Node]()

        init(_ str: String) {
            nodes.append(Node())
            for i in 0..<str.count {
                let startIndex = str.index(str.startIndex, offsetBy: i)
                let suffix = String(str[startIndex...])
                addSuffix(suffix)
            }
        }

        private func addSuffix(_ suf: String) {
            var n = 0
            var i = 0
            while i < suf.count {
                let bIndex = suf.index(suf.startIndex, offsetBy: i)
                let b = suf[bIndex]
                let children = nodes[n].ch
                var x2 = 0
                var n2 = 0  // Initialize n2 with a default value

                while true {
                    if x2 == children.count {
                        // no matching child, remainder of suf becomes new node.
                        n2 = nodes.count
                        let temp = Node()
                        let startIndex = suf.index(suf.startIndex, offsetBy: i)
                        temp.sub = String(suf[startIndex...])
                        nodes.append(temp)
                        nodes[n].ch.append(n2)
                        return
                    }
                    n2 = children[x2]
                    let firstCharIndex = nodes[n2].sub.startIndex
                    if nodes[n2].sub[firstCharIndex] == b {
                        break
                    }
                    x2 += 1
                }

                // find prefix of remaining suffix in common with child
                let sub2 = nodes[n2].sub
                var j = 0

                while j < sub2.count {
                    let sufIndex = suf.index(suf.startIndex, offsetBy: i + j)
                    let sub2Index = sub2.index(sub2.startIndex, offsetBy: j)

                    if suf[sufIndex] != sub2[sub2Index] {
                        // split n2
                        let n3 = n2
                        // new node for the part in common
                        n2 = nodes.count
                        let temp = Node()
                        let endIndex = sub2.index(sub2.startIndex, offsetBy: j)
                        temp.sub = String(sub2[sub2.startIndex..<endIndex])
                        temp.ch.append(n3)
                        nodes.append(temp)
                        // old node loses the part in common
                        nodes[n3].sub = String(sub2[endIndex...])
                        nodes[n].ch[x2] = n2
                        break  // continue down the tree
                    }
                    j += 1
                }

                i += j  // advance past part in common
                n = n2  // continue down the tree
            }
        }

        func visualize() {
            if nodes.isEmpty {
                print("<empty>")
                return
            }
            visualize_f(0, "")
        }

        private func visualize_f(_ n: Int, _ pre: String) {
            let children = nodes[n].ch
            if children.isEmpty {
                print("- \(nodes[n].sub)")
                return
            }
            print("┐ \(nodes[n].sub)")
            for i in 0..<children.count - 1 {
                let c = children[i]
                print("\(pre)├─", terminator: "")
                visualize_f(c, pre + "│ ")
            }
            print("\(pre)└─", terminator: "")
            visualize_f(children[children.count - 1], pre + "  ")
        }
    }

    static func main() {
        SuffixTree("banana$").visualize()
    }
}

// Call the main function to run the program
SuffixTreeProblem.main()
