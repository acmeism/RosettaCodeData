package main

import (
  "log"
  "sort"
)

func main() {
  log.Println(jortSort([]int{1, 2, 1, 11, 213, 2, 4})) //false
  log.Println(jortSort([]int{0, 1, 0, 0, 0, 0}))       //false
  log.Println(jortSort([]int{1, 2, 4, 11, 22, 22}))    //true
  log.Println(jortSort([]int{0, 0, 0, 1, 2, 2}))       //true
}

func jortSort(a []int) bool {
  c := make([]int, len(a))
  copy(c, a)
  sort.Ints(a)
  for k, v := range c {
    if v == a[k] {
      continue
    } else {
      return false
    }
  }
  return true
}
