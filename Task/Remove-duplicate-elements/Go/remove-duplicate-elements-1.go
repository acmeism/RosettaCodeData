package main
import "fmt"

func uniq(list []int) []int {
  unique_set := make(map[int] bool, len(list))
  for _, x := range list {
    unique_set[x] = true
  }
  result := make([]int, len(unique_set))
  i := 0
  for x := range unique_set {
    result[i] = x
    i++
  }
  return result
}

func main() {
  fmt.Println(uniq([]int {1,2,3,2,3,4})) // prints: [3 1 4 2]
}
