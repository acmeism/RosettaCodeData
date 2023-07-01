package main

import (
  "sort"
  "container/heap"
  "fmt"
)

type HeapHelper struct {
    container sort.Interface
    length    int
}

func (self HeapHelper) Len() int { return self.length }
// We want a max-heap, hence reverse the comparison
func (self HeapHelper) Less(i, j int) bool { return self.container.Less(j, i) }
func (self HeapHelper) Swap(i, j int) { self.container.Swap(i, j) }
// this should not be called
func (self *HeapHelper) Push(x interface{}) { panic("impossible") }
func (self *HeapHelper) Pop() interface{} {
    self.length--
    return nil // return value not used
}

func heapSort(a sort.Interface) {
    helper := HeapHelper{ a, a.Len() }
    heap.Init(&helper)
    for helper.length > 0 {
        heap.Pop(&helper)
    }
}

func main() {
    a := []int{170, 45, 75, -90, -802, 24, 2, 66}
    fmt.Println("before:", a)
    heapSort(sort.IntSlice(a))
    fmt.Println("after: ", a)
}
