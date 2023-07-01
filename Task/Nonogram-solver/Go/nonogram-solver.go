package main

import (
    "fmt"
    "strings"
)

type BitSet []bool

func (bs BitSet) and(other BitSet) {
    for i := range bs {
        if bs[i] && other[i] {
            bs[i] = true
        } else {
            bs[i] = false
        }
    }
}

func (bs BitSet) or(other BitSet) {
    for i := range bs {
        if bs[i] || other[i] {
            bs[i] = true
        } else {
            bs[i] = false
        }
    }
}

func iff(cond bool, s1, s2 string) string {
    if cond {
        return s1
    }
    return s2
}

func newPuzzle(data [2]string) {
    rowData := strings.Fields(data[0])
    colData := strings.Fields(data[1])
    rows := getCandidates(rowData, len(colData))
    cols := getCandidates(colData, len(rowData))

    for {
        numChanged := reduceMutual(cols, rows)
        if numChanged == -1 {
            fmt.Println("No solution")
            return
        }
        if numChanged == 0 {
            break
        }
    }

    for _, row := range rows {
        for i := 0; i < len(cols); i++ {
            fmt.Printf(iff(row[0][i], "# ", ". "))
        }
        fmt.Println()
    }
    fmt.Println()
}

// collect all possible solutions for the given clues
func getCandidates(data []string, le int) [][]BitSet {
    var result [][]BitSet
    for _, s := range data {
        var lst []BitSet
        a := []byte(s)
        sumBytes := 0
        for _, b := range a {
            sumBytes += int(b - 'A' + 1)
        }
        prep := make([]string, len(a))
        for i, b := range a {
            prep[i] = strings.Repeat("1", int(b-'A'+1))
        }
        for _, r := range genSequence(prep, le-sumBytes+1) {
            bits := []byte(r[1:])
            bitset := make(BitSet, len(bits))
            for i, b := range bits {
                bitset[i] = b == '1'
            }
            lst = append(lst, bitset)
        }
        result = append(result, lst)
    }
    return result
}

func genSequence(ones []string, numZeros int) []string {
    le := len(ones)
    if le == 0 {
        return []string{strings.Repeat("0", numZeros)}
    }
    var result []string
    for x := 1; x < numZeros-le+2; x++ {
        skipOne := ones[1:]
        for _, tail := range genSequence(skipOne, numZeros-x) {
            result = append(result, strings.Repeat("0", x)+ones[0]+tail)
        }
    }
    return result
}

/* If all the candidates for a row have a value in common for a certain cell,
   then it's the only possible outcome, and all the candidates from the
   corresponding column need to have that value for that cell too. The ones
   that don't, are removed. The same for all columns. It goes back and forth,
   until no more candidates can be removed or a list is empty (failure).
*/

func reduceMutual(cols, rows [][]BitSet) int {
    countRemoved1 := reduce(cols, rows)
    if countRemoved1 == -1 {
        return -1
    }
    countRemoved2 := reduce(rows, cols)
    if countRemoved2 == -1 {
        return -1
    }
    return countRemoved1 + countRemoved2
}

func reduce(a, b [][]BitSet) int {
    countRemoved := 0
    for i := 0; i < len(a); i++ {
        commonOn := make(BitSet, len(b))
        for j := 0; j < len(b); j++ {
            commonOn[j] = true
        }
        commonOff := make(BitSet, len(b))

        // determine which values all candidates of a[i] have in common
        for _, candidate := range a[i] {
            commonOn.and(candidate)
            commonOff.or(candidate)
        }

        // remove from b[j] all candidates that don't share the forced values
        for j := 0; j < len(b); j++ {
            fi, fj := i, j
            for k := len(b[j]) - 1; k >= 0; k-- {
                cnd := b[j][k]
                if (commonOn[fj] && !cnd[fi]) || (!commonOff[fj] && cnd[fi]) {
                    lb := len(b[j])
                    copy(b[j][k:], b[j][k+1:])
                    b[j][lb-1] = nil
                    b[j] = b[j][:lb-1]
                    countRemoved++
                }
            }
            if len(b[j]) == 0 {
                return -1
            }
        }
    }
    return countRemoved
}

func main() {
    p1 := [2]string{"C BA CB BB F AE F A B", "AB CA AE GA E C D C"}

    p2 := [2]string{
        "F CAC ACAC CN AAA AABB EBB EAA ECCC HCCC",
        "D D AE CD AE A DA BBB CC AAB BAA AAB DA AAB AAA BAB AAA CD BBA DA",
    }

    p3 := [2]string{
        "CA BDA ACC BD CCAC CBBAC BBBBB BAABAA ABAD AABB BBH " +
            "BBBD ABBAAA CCEA AACAAB BCACC ACBH DCH ADBE ADBB DBE ECE DAA DB CC",
        "BC CAC CBAB BDD CDBDE BEBDF ADCDFA DCCFB DBCFC ABDBA BBF AAF BADB DBF " +
            "AAAAD BDG CEF CBDB BBB FC",
    }

    p4 := [2]string{
        "E BCB BEA BH BEK AABAF ABAC BAA BFB OD JH BADCF Q Q R AN AAN EI H G",
        "E CB BAB AAA AAA AC BB ACC ACCA AGB AIA AJ AJ " +
            "ACE AH BAF CAG DAG FAH FJ GJ ADK ABK BL CM",
    }

    for _, puzzleData := range [][2]string{p1, p2, p3, p4} {
        newPuzzle(puzzleData)
    }
}
