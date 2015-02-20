package main

import (
  "fmt"
  "sort"
)

type Node struct {
    val int
    back *Node
}

func lis (n []int) (result []int) {
  var pileTops []*Node
  // sort into piles
  for _, x := range n {
    j := sort.Search(len(pileTops), func (i int) bool { return pileTops[i].val >= x })
    node := &Node{ x, nil }
    if j != 0 { node.back = pileTops[j-1] }
    if j != len(pileTops) {
      pileTops[j] = node
    } else {
      pileTops = append(pileTops, node)
    }
  }

  if len(pileTops) == 0 { return []int{} }
  for node := pileTops[len(pileTops)-1]; node != nil; node = node.back {
    result = append(result, node.val)
  }
  // reverse
  for i := 0; i < len(result)/2; i++ {
    result[i], result[len(result)-i-1] = result[len(result)-i-1], result[i]
  }
  return
}

func main() {
    for _, d := range [][]int{{3, 2, 6, 4, 5, 1},
            {0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15}} {
        fmt.Printf("an L.I.S. of %v is %v\n", d, lis(d))
    }
}
