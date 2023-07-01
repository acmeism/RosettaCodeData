package main

import (
    "fmt"
    "strconv"
    "strings"
    "time"
)

type assoc map[string]int

// Converts a string of the form "[1 2]" into a slice of ints: {1, 2}
func asSlice(s string) []int {
    split := strings.Split(s[1:len(s)-1], " ")
    le := len(split)
    res := make([]int, le)
    for i := 0; i < le; i++ {
        res[i], _ = strconv.Atoi(split[i])
    }
    return res
}

// Merges two assocs into one. If the same key is present in both assocs
// its value will be the one in the second assoc.
func merge(m1, m2 assoc) assoc {
    m3 := make(assoc)
    for k, v := range m1 {
        m3[k] = v
    }
    for k, v := range m2 {
        m3[k] = v
    }
    return m3
}

// Finds the maximum value in 'dict' and returns the first key
// it finds (iteration order is undefined) with that value.
func findMax(dict assoc) string {
    max := -1
    maxKey := ""
    for k, v := range dict {
        if v > max {
            max = v
            maxKey = k
        }
    }
    return maxKey
}

// Creates a new slice of ints by reversing an existing one.
func reverse(s []int) []int {
    le := len(s)
    rev := make([]int, le)
    for i := 0; i < le; i++ {
        rev[i] = s[le-1-i]
    }
    return rev
}

func pancake(n int) (string, int) {
    numStacks := 1
    gs := make([]int, n)
    for i := 0; i < n; i++ {
        gs[i] = i + 1
    }
    goalStack := fmt.Sprintf("%v", gs)
    stacks := assoc{goalStack: 0}
    newStacks := assoc{goalStack: 0}
    for i := 1; i <= 1000; i++ {
        nextStacks := assoc{}
        for key := range newStacks {
            arr := asSlice(key)
            for pos := 2; pos <= n; pos++ {
                t := append(reverse(arr[0:pos]), arr[pos:len(arr)]...)
                newStack := fmt.Sprintf("%v", t)
                if _, ok := stacks[newStack]; !ok {
                    nextStacks[newStack] = i
                }
            }
        }
        newStacks = nextStacks
        stacks = merge(stacks, newStacks)
        perms := len(stacks)
        if perms == numStacks {
            return findMax(stacks), i - 1
        }
        numStacks = perms
    }
    return "", 0
}

func main() {
    start := time.Now()
    fmt.Println("The maximum number of flips to sort a given number of elements is:")
    for i := 1; i <= 10; i++ {
        example, steps := pancake(i)
        fmt.Printf("pancake(%2d) = %-2d  example: %s\n", i, steps, example)
    }
    fmt.Printf("\nTook %s\n", time.Since(start))
}
