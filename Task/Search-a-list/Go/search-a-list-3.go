package main

import "fmt"

func main() {
    m := map[string][]int{}
    for i, needle := range haystack {
        m[needle] = append(m[needle], i)
    }
    for _, n := range []string{"soap", "gold", "fire"} {
        fmt.Println(n, m[n])
    }
}
