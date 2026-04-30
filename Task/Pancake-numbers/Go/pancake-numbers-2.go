package main

import (
    "fmt"
    "strconv"
    "strings"
    "time"
)

const MAX_N = 10

// store sequences in 2 int64s, 5 bits per number
// (12 in each int64, ignoring the top 4 bits)
// this will support length 24 or less
type Sequence struct {
    num1 int64
    num2 int64
}

// get the number at position n in the sequence
func (s *Sequence) get(n int64) int64 {
    if n > 12 {
        n = (n - 12) * 5
        return (s.num2 & (31 << n)) >> n
    } else {
	    n *= 5
        return (s.num1 & (31 << n)) >> n
    }
}

// set value at position n in the sequence
func (s *Sequence) set(n int64, value int64) {
    if n > 12 {
        n = (n - 12) * 5
        var bits int64 = 31 << n
        s.num2 = (s.num2 | bits) ^ bits | (value << n)
    } else {
	    n *= 5
        var bits int64 = 31 << n
        s.num1 = (s.num1 | bits) ^ bits | (value << n)
    }
}

type assoc map[Sequence]int

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
func findMax(dict assoc) Sequence {
    max := -1
    var maxKey Sequence
    for k, v := range dict {
	if v > max {
            max = v
            maxKey = k
        }
    }
    return maxKey
}

// reverse order up to pos
func reorder(stack Sequence, pos int64) Sequence {
    for i := int64(0); i < pos / 2; i++ {
        j := pos - i - 1
        a := stack.get(i)
	    b := stack.get(j)
	    stack.set(i, b)
	    stack.set(j, a)
    }
    return stack
}

func pancake(n int64) (Sequence, int) {
    numStacks := 1

    goalStack := Sequence{}
    for i := int64(0); i < n; i++ {
        goalStack.set(i, i+1)
    }
    stacks := assoc{goalStack: 0}
    newStacks := assoc{goalStack: 0}
    for i := 1; ; i++ {
        nextStacks := assoc{}
        for stack := range newStacks {
            for pos := int64(2); pos <= n; pos++ {
                newStack := reorder(stack, pos)
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
    return Sequence{}, 0
}

func main() {
    start := time.Now()
    fmt.Println("The maximum number of flips to sort a given number of elements is:")
    for i := int64(1); i <= MAX_N; i++ {
        example, steps := pancake(i)
        example_strs := make([]string, i)
	    for j := int64(0); j < i; j++ {
            example_strs[j] = strconv.Itoa(int(example.get(j)))
        }
        fmt.Printf("pancake(%2d) = %-2d  example: %s\n", i, steps, strings.Join(example_strs, " "))
    }
    fmt.Printf("\nTook %s\n", time.Since(start))
}
