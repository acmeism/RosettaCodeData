package main

import (
    "fmt"
    "math/big"
    "time"
)

var maxChar = 128

type Node struct {
    children    []*Node
    suffixLink  *Node
    start       int
    end         *int
    suffixIndex int
}

var (
    text                 string
    root                 *Node
    lastNewNode          *Node
    activeNode           *Node
    activeEdge           = -1
    activeLength         = 0
    remainingSuffixCount = 0
    leafEnd              = -1
    rootEnd              *int
    splitEnd             *int
    size                 = -1
)

func newNode(start int, end *int) *Node {
    node := new(Node)
    node.children = make([]*Node, maxChar)
    node.suffixLink = root
    node.start = start
    node.end = end
    node.suffixIndex = -1
    return node
}

func edgeLength(n *Node) int {
    if n == root {
        return 0
    }
    return *(n.end) - n.start + 1
}

func walkDown(currNode *Node) bool {
    if activeLength >= edgeLength(currNode) {
        activeEdge += edgeLength(currNode)
        activeLength -= edgeLength(currNode)
        activeNode = currNode
        return true
    }
    return false
}

func extendSuffixTree(pos int) {
    leafEnd = pos
    remainingSuffixCount++
    lastNewNode = nil
    for remainingSuffixCount > 0 {
        if activeLength == 0 {
            activeEdge = pos
        }
        if activeNode.children[text[activeEdge]] == nil {
            activeNode.children[text[activeEdge]] = newNode(pos, &leafEnd)
            if lastNewNode != nil {
                lastNewNode.suffixLink = activeNode
                lastNewNode = nil
            }
        } else {
            next := activeNode.children[text[activeEdge]]
            if walkDown(next) {
                continue
            }
            if text[next.start+activeLength] == text[pos] {
                if lastNewNode != nil && activeNode != root {
                    lastNewNode.suffixLink = activeNode
                    lastNewNode = nil
                }
                activeLength++
                break
            }
            temp := next.start + activeLength - 1
            splitEnd = &temp
            split := newNode(next.start, splitEnd)
            activeNode.children[text[activeEdge]] = split
            split.children[text[pos]] = newNode(pos, &leafEnd)
            next.start += activeLength
            split.children[text[next.start]] = next
            if lastNewNode != nil {
                lastNewNode.suffixLink = split
            }
            lastNewNode = split
        }
        remainingSuffixCount--
        if activeNode == root && activeLength > 0 {
            activeLength--
            activeEdge = pos - remainingSuffixCount + 1
        } else if activeNode != root {
            activeNode = activeNode.suffixLink
        }
    }
}

func setSuffixIndexByDFS(n *Node, labelHeight int) {
    if n == nil {
        return
    }
    if n.start != -1 {
        // Uncomment line below to print suffix tree
        // fmt.Print(text[n.start: *(n.end) +1])
    }
    leaf := 1
    for i := 0; i < maxChar; i++ {
        if n.children[i] != nil {
            // Uncomment the 3 lines below to print suffix index
            //if leaf == 1 && n.start != -1 {
            //    fmt.Printf(" [%d]\n", n.suffixIndex)
            //}
            leaf = 0
            setSuffixIndexByDFS(n.children[i], labelHeight+edgeLength(n.children[i]))
        }
    }
    if leaf == 1 {
        n.suffixIndex = size - labelHeight
        // Uncomment line below to print suffix index
        //fmt.Printf(" [%d]\n", n.suffixIndex)
    }
}

func buildSuffixTree() {
    size = len(text)
    temp := -1
    rootEnd = &temp
    root = newNode(-1, rootEnd)
    activeNode = root
    for i := 0; i < size; i++ {
        extendSuffixTree(i)
    }
    labelHeight := 0
    setSuffixIndexByDFS(root, labelHeight)
}

func doTraversal(n *Node, labelHeight int, maxHeight, substringStartIndex *int) {
    if n == nil {
        return
    }
    if n.suffixIndex == -1 {
        for i := 0; i < maxChar; i++ {
            if n.children[i] != nil {
                doTraversal(n.children[i], labelHeight+edgeLength(n.children[i]),
                    maxHeight, substringStartIndex)
            }
        }
    } else if n.suffixIndex > -1 && (*maxHeight < labelHeight-edgeLength(n)) {
        *maxHeight = labelHeight - edgeLength(n)
        *substringStartIndex = n.suffixIndex
    }
}

func getLongestRepeatedSubstring(s string) {
    maxHeight := 0
    substringStartIndex := 0
    doTraversal(root, 0, &maxHeight, &substringStartIndex)
    // Uncomment line below to print maxHeight and substringStartIndex
    // fmt.Printf("maxHeight %d, substringStartIndex %d\n", maxHeight, substringStartIndex)
    if s == "" {
        fmt.Printf("  %s is: ", text)
    } else {
        fmt.Printf("  %s is: ", s)
    }
    k := 0
    for ; k < maxHeight; k++ {
        fmt.Printf("%c", text[k+substringStartIndex])
    }
    if k == 0 {
        fmt.Print("No repeated substring")
    }
    fmt.Println()
}

func calculatePi() *big.Float {
    one := big.NewFloat(1)
    two := big.NewFloat(2)
    four := big.NewFloat(4)
    prec := uint(325 * 1024) // enough to calculate Pi to 100,182 decimal digits

    a := big.NewFloat(1).SetPrec(prec)
    g := new(big.Float).SetPrec(prec)

    // temporary variables
    t := new(big.Float).SetPrec(prec)
    u := new(big.Float).SetPrec(prec)

    g.Quo(a, t.Sqrt(two))
    sum := new(big.Float)
    pow := big.NewFloat(2)

    for a.Cmp(g) != 0 {
        t.Add(a, g)
        t.Quo(t, two)
        g.Sqrt(u.Mul(a, g))
        a.Set(t)
        pow.Mul(pow, two)
        t.Sub(t.Mul(a, a), u.Mul(g, g))
        sum.Add(sum, t.Mul(t, pow))
    }

    t.Mul(a, a)
    t.Mul(t, four)
    pi := t.Quo(t, u.Sub(one, sum))
    return pi
}

func main() {
    tests := []string{
        "GEEKSFORGEEKS$",
        "AAAAAAAAAA$",
        "ABCDEFG$",
        "ABABABA$",
        "ATCGATCGA$",
        "banana$",
        "abcpqrabpqpq$",
        "pqrpqpqabab$",
    }
    fmt.Println("Longest Repeated Substring in:\n")
    for _, test := range tests {
        text = test
        buildSuffixTree()
        getLongestRepeatedSubstring("")
    }
    fmt.Println()

    pi := calculatePi()
    piStr := fmt.Sprintf("%v", pi)
    piStr = piStr[2:] // remove initial 3.
    numbers := []int{1e3, 1e4, 1e5}
    maxChar = 58
    for _, number := range numbers {
        start := time.Now()
        text = piStr[0:number] + "$"
        buildSuffixTree()
        getLongestRepeatedSubstring(fmt.Sprintf("first %d d.p. of Pi", number))
        elapsed := time.Now().Sub(start)
        fmt.Printf("  (this took %s)\n\n", elapsed)
    }
}
