package main

import (
    "fmt"
    "strconv"
    "strings"
)

type sandpile struct{ a [9]int }

var neighbors = [][]int{
    {1, 3}, {0, 2, 4}, {1, 5}, {0, 4, 6}, {1, 3, 5, 7}, {2, 4, 8}, {3, 7}, {4, 6, 8}, {5, 7},
}

// 'a' is in row order
func newSandpile(a [9]int) *sandpile { return &sandpile{a} }

func (s *sandpile) plus(other *sandpile) *sandpile {
    b := [9]int{}
    for i := 0; i < 9; i++ {
        b[i] = s.a[i] + other.a[i]
    }
    return &sandpile{b}
}

func (s *sandpile) isStable() bool {
    for _, e := range s.a {
        if e > 3 {
            return false
        }
    }
    return true
}

// just topples once so we can observe intermediate results
func (s *sandpile) topple() {
    for i := 0; i < 9; i++ {
        if s.a[i] > 3 {
            s.a[i] -= 4
            for _, j := range neighbors[i] {
                s.a[j]++
            }
            return
        }
    }
}

func (s *sandpile) String() string {
    var sb strings.Builder
    for i := 0; i < 3; i++ {
        for j := 0; j < 3; j++ {
            sb.WriteString(strconv.Itoa(s.a[3*i+j]) + " ")
        }
        sb.WriteString("\n")
    }
    return sb.String()
}

func main() {
    fmt.Println("Avalanche of topplings:\n")
    s4 := newSandpile([9]int{4, 3, 3, 3, 1, 2, 0, 2, 3})
    fmt.Println(s4)
    for !s4.isStable() {
        s4.topple()
        fmt.Println(s4)
    }

    fmt.Println("Commutative additions:\n")
    s1 := newSandpile([9]int{1, 2, 0, 2, 1, 1, 0, 1, 3})
    s2 := newSandpile([9]int{2, 1, 3, 1, 0, 1, 0, 1, 0})
    s3_a := s1.plus(s2)
    for !s3_a.isStable() {
        s3_a.topple()
    }
    s3_b := s2.plus(s1)
    for !s3_b.isStable() {
        s3_b.topple()
    }
    fmt.Printf("%s\nplus\n\n%s\nequals\n\n%s\n", s1, s2, s3_a)
    fmt.Printf("and\n\n%s\nplus\n\n%s\nalso equals\n\n%s\n", s2, s1, s3_b)

    fmt.Println("Addition of identity sandpile:\n")
    s3 := newSandpile([9]int{3, 3, 3, 3, 3, 3, 3, 3, 3})
    s3_id := newSandpile([9]int{2, 1, 2, 1, 0, 1, 2, 1, 2})
    s4 = s3.plus(s3_id)
    for !s4.isStable() {
        s4.topple()
    }
    fmt.Printf("%s\nplus\n\n%s\nequals\n\n%s\n", s3, s3_id, s4)

    fmt.Println("Addition of identities:\n")
    s5 := s3_id.plus(s3_id)
    for !s5.isStable() {
        s5.topple()
    }
    fmt.Printf("%s\nplus\n\n%s\nequals\n\n%s", s3_id, s3_id, s5)
}
