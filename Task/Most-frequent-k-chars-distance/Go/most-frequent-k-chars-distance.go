package main

import (
    "fmt"
    "sort"
)

type cf struct {
    c rune
    f int
}

func reverseStr(s string) string {
    runes := []rune(s)
    for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
        runes[i], runes[j] = runes[j], runes[i]
    }
    return string(runes)
}

func indexOfCf(cfs []cf, r rune) int {
    for i, cf := range cfs {
        if cf.c == r {
            return i
        }
    }
    return -1
}

func minOf(i, j int) int {
    if i < j {
        return i
    }
    return j
}

func mostFreqKHashing(input string, k int) string {
    var cfs []cf
    for _, r := range input {
        ix := indexOfCf(cfs, r)
        if ix >= 0 {
            cfs[ix].f++
        } else {
            cfs = append(cfs, cf{r, 1})
        }
    }
    sort.SliceStable(cfs, func(i, j int) bool {
        return cfs[i].f > cfs[j].f // descending, preserves order when equal
    })
    acc := ""
    min := minOf(len(cfs), k)
    for _, cf := range cfs[:min] {
        acc += fmt.Sprintf("%c%c", cf.c, cf.f)
    }
    return acc
}

func mostFreqKSimilarity(input1, input2 string) int {
    similarity := 0
    runes1, runes2 := []rune(input1), []rune(input2)
    for i := 0; i < len(runes1); i += 2 {
        for j := 0; j < len(runes2); j += 2 {
            if runes1[i] == runes2[j] {
                freq1, freq2 := runes1[i+1], runes2[j+1]
                if freq1 != freq2 {
                    continue // assuming here that frequencies need to match
                }
                similarity += int(freq1)
            }
        }
    }
    return similarity
}

func mostFreqKSDF(input1, input2 string, k, maxDistance int) {
    fmt.Println("input1 :", input1)
    fmt.Println("input2 :", input2)
    s1 := mostFreqKHashing(input1, k)
    s2 := mostFreqKHashing(input2, k)
    fmt.Printf("mfkh(input1, %d) = ", k)
    for i, c := range s1 {
        if i%2 == 0 {
            fmt.Printf("%c", c)
        } else {
            fmt.Printf("%d", c)
        }
    }
    fmt.Printf("\nmfkh(input2, %d) = ", k)
    for i, c := range s2 {
        if i%2 == 0 {
            fmt.Printf("%c", c)
        } else {
            fmt.Printf("%d", c)
        }
    }
    result := maxDistance - mostFreqKSimilarity(s1, s2)
    fmt.Printf("\nSDF(input1, input2, %d, %d) = %d\n\n", k, maxDistance, result)
}

func main() {
    pairs := [][2]string{
        {"research", "seeking"},
        {"night", "nacht"},
        {"my", "a"},
        {"research", "research"},
        {"aaaaabbbb", "ababababa"},
        {"significant", "capabilities"},
    }
    for _, pair := range pairs {
        mostFreqKSDF(pair[0], pair[1], 2, 10)
    }

    s1 := "LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV"
    s2 := "EWIWGGFSVDKATLNRFFAFHFILPFTMVALAGVHLTFLHETGSNNPLGLTSDSDKIPFHPYYTIKDFLG"
    mostFreqKSDF(s1, s2, 2, 100)
    s1 = "abracadabra12121212121abracadabra12121212121"
    s2 = reverseStr(s1)
    mostFreqKSDF(s1, s2, 2, 100)
}
