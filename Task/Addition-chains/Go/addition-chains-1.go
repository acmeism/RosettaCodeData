package main

import "fmt"

var example []int

func reverse(s []int) {
    for i, j := 0, len(s)-1; i < j; i, j = i+1, j-1 {
        s[i], s[j] = s[j], s[i]
    }
}

func checkSeq(pos, n, minLen int, seq []int) (int, int) {
    switch {
    case pos > minLen || seq[0] > n:
        return minLen, 0
    case seq[0] == n:
        example = seq
        return pos, 1
    case pos < minLen:
        return tryPerm(0, pos, n, minLen, seq)
    default:
        return minLen, 0
    }
}

func tryPerm(i, pos, n, minLen int, seq []int) (int, int) {
    if i > pos {
        return minLen, 0
    }
    seq2 := make([]int, len(seq)+1)
    copy(seq2[1:], seq)
    seq2[0] = seq[0] + seq[i]
    res11, res12 := checkSeq(pos+1, n, minLen, seq2)
    res21, res22 := tryPerm(i+1, pos, n, res11, seq)
    switch {
    case res21 < res11:
        return res21, res22
    case res21 == res11:
        return res21, res12 + res22
    default:
        fmt.Println("Error in tryPerm")
        return 0, 0
    }
}

func initTryPerm(x, minLen int) (int, int) {
    return tryPerm(0, 0, x, minLen, []int{1})
}

func findBrauer(num, minLen, nbLimit int) {
    actualMin, brauer := initTryPerm(num, minLen)
    fmt.Println("\nN =", num)
    fmt.Printf("Minimum length of chains : L(%d) = %d\n", num, actualMin)
    fmt.Println("Number of minimum length Brauer chains :", brauer)
    if brauer > 0 {
        reverse(example)
        fmt.Println("Brauer example :", example)
    }
    example = nil
    if num <= nbLimit {
        nonBrauer := findNonBrauer(num, actualMin+1, brauer)
        fmt.Println("Number of minimum length non-Brauer chains :", nonBrauer)
        if nonBrauer > 0 {
            fmt.Println("Non-Brauer example :", example)
        }
        example = nil
    } else {
        println("Non-Brauer analysis suppressed")
    }
}

func isAdditionChain(a []int) bool {
    for i := 2; i < len(a); i++ {
        if a[i] > a[i-1]*2 {
            return false
        }
        ok := false
    jloop:
        for j := i - 1; j >= 0; j-- {
            for k := j; k >= 0; k-- {
                if a[j]+a[k] == a[i] {
                    ok = true
                    break jloop
                }
            }
        }
        if !ok {
            return false
        }
    }
    if example == nil && !isBrauer(a) {
        example = make([]int, len(a))
        copy(example, a)
    }
    return true
}

func isBrauer(a []int) bool {
    for i := 2; i < len(a); i++ {
        ok := false
        for j := i - 1; j >= 0; j-- {
            if a[i-1]+a[j] == a[i] {
                ok = true
                break
            }
        }
        if !ok {
            return false
        }
    }
    return true
}

func nextChains(index, le int, seq []int, pcount *int) {
    for {
        if index < le-1 {
            nextChains(index+1, le, seq, pcount)
        }
        if seq[index]+le-1-index >= seq[le-1] {
            return
        }
        seq[index]++
        for i := index + 1; i < le-1; i++ {
            seq[i] = seq[i-1] + 1
        }
        if isAdditionChain(seq) {
            (*pcount)++
        }
    }
}

func findNonBrauer(num, le, brauer int) int {
    seq := make([]int, le)
    seq[0] = 1
    seq[le-1] = num
    for i := 1; i < le-1; i++ {
        seq[i] = seq[i-1] + 1
    }
    count := 0
    if isAdditionChain(seq) {
        count = 1
    }
    nextChains(2, le, seq, &count)
    return count - brauer
}

func main() {
    nums := []int{7, 14, 21, 29, 32, 42, 64, 47, 79, 191, 382, 379}
    fmt.Println("Searching for Brauer chains up to a minimum length of 12:")
    for _, num := range nums {
        findBrauer(num, 12, 79)
    }
}
