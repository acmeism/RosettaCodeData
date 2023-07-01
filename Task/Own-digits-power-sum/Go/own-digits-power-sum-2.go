package main

import "fmt"

const maxBase = 10

var usedDigits = [maxBase]int{}
var powerDgt = [maxBase][maxBase]uint64{}
var numbers []uint64

func initPowerDgt() {
    for i := 1; i < maxBase; i++ {
        powerDgt[0][i] = 1
    }
    for j := 1; j < maxBase; j++ {
        for i := 0; i < maxBase; i++ {
            powerDgt[j][i] = powerDgt[j-1][i] * uint64(i)
        }
    }
}

func calcNum(depth int, used [maxBase]int) uint64 {
    if depth < 3 {
        return 0
    }
    result := uint64(0)
    for i := 1; i < maxBase; i++ {
        if used[i] > 0 {
            result += uint64(used[i]) * powerDgt[depth][i]
        }
    }
    if result == 0 {
        return 0
    }
    n := result
    for {
        r := n / maxBase
        used[n-r*maxBase]--
        n = r
        depth--
        if r == 0 {
            break
        }
    }
    if depth != 0 {
        return 0
    }
    i := 1
    for i < maxBase && used[i] == 0 {
        i++
    }
    if i >= maxBase {
        numbers = append(numbers, result)
    }
    return 0
}

func nextDigit(dgt, depth int) {
    if depth < maxBase-1 {
        for i := dgt; i < maxBase; i++ {
            usedDigits[dgt]++
            nextDigit(i, depth+1)
            usedDigits[dgt]--
        }
    }
    if dgt == 0 {
        dgt = 1
    }
    for i := dgt; i < maxBase; i++ {
        usedDigits[i]++
        calcNum(depth, usedDigits)
        usedDigits[i]--
    }
}

func main() {
    initPowerDgt()
    nextDigit(0, 0)

    // sort and remove duplicates
    for i := 0; i < len(numbers)-1; i++ {
        for j := i + 1; j < len(numbers); j++ {
            if numbers[j] < numbers[i] {
                numbers[i], numbers[j] = numbers[j], numbers[i]
            }
        }
    }
    j := 0
    for i := 1; i < len(numbers); i++ {
        if numbers[i] != numbers[j] {
            j++
            numbers[i], numbers[j] = numbers[j], numbers[i]
        }
    }
    numbers = numbers[0 : j+1]
    fmt.Println("Own digits power sums for N = 3 to 9 inclusive:")
    for _, n := range numbers {
        fmt.Println(n)
    }
}
