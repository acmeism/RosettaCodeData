package main

import (
  "fmt"
  "container/heap"
  "sort"
)

type IntPile []int
func (self IntPile) Top() int { return self[len(self)-1] }
func (self *IntPile) Pop() int {
    x := (*self)[len(*self)-1]
    *self = (*self)[:len(*self)-1]
    return x
}

type IntPilesHeap []IntPile
func (self IntPilesHeap) Len() int { return len(self) }
func (self IntPilesHeap) Less(i, j int) bool { return self[i].Top() < self[j].Top() }
func (self IntPilesHeap) Swap(i, j int) { self[i], self[j] = self[j], self[i] }
func (self *IntPilesHeap) Push(x interface{}) { *self = append(*self, x.(IntPile)) }
func (self *IntPilesHeap) Pop() interface{} {
    x := (*self)[len(*self)-1]
    *self = (*self)[:len(*self)-1]
    return x
}

func patience_sort (n []int) {
  var piles []IntPile
  // sort into piles
  for _, x := range n {
    j := sort.Search(len(piles), func (i int) bool { return piles[i].Top() >= x })
    if j != len(piles) {
      piles[j] = append(piles[j], x)
    } else {
      piles = append(piles, IntPile{ x })
    }
  }

  // priority queue allows us to merge piles efficiently
  hp := IntPilesHeap(piles)
  heap.Init(&hp)
  for i, _ := range n {
    smallPile := heap.Pop(&hp).(IntPile)
    n[i] = smallPile.Pop()
    if len(smallPile) != 0 {
      heap.Push(&hp, smallPile)
    }
  }
  if len(hp) != 0 {
    panic("something went wrong")
  }
}

func main() {
    a := []int{4, 65, 2, -31, 0, 99, 83, 782, 1}
    patience_sort(a)
    fmt.Println(a)
}
