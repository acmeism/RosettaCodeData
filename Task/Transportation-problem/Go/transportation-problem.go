package main

import (
    "bufio"
    "container/list"
    "fmt"
    "io/ioutil"
    "log"
    "math"
    "os"
    "strconv"
)

type shipment struct {
    quantity, costPerUnit float64
    r, c                  int
}

var shipZero = shipment{}

type transport struct {
    filename       string
    supply, demand []int
    costs          [][]float64
    matrix         [][]shipment
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func minOf(i, j int) int {
    if i < j {
        return i
    }
    return j
}

func newTransport(filename string) *transport {
    file, err := os.Open(filename)
    check(err)
    defer file.Close()
    scanner := bufio.NewScanner(file)
    scanner.Split(bufio.ScanWords)
    scanner.Scan()
    numSources, err := strconv.Atoi(scanner.Text())
    check(err)
    scanner.Scan()
    numDests, err := strconv.Atoi(scanner.Text())
    check(err)
    src := make([]int, numSources)
    for i := 0; i < numSources; i++ {
        scanner.Scan()
        src[i], err = strconv.Atoi(scanner.Text())
        check(err)
    }
    dst := make([]int, numDests)
    for i := 0; i < numDests; i++ {
        scanner.Scan()
        dst[i], err = strconv.Atoi(scanner.Text())
        check(err)
    }

    // fix imbalance
    totalSrc := 0
    for _, v := range src {
        totalSrc += v
    }
    totalDst := 0
    for _, v := range dst {
        totalDst += v
    }
    diff := totalSrc - totalDst
    if diff > 0 {
        dst = append(dst, diff)
    } else if diff < 0 {
        src = append(src, -diff)
    }

    costs := make([][]float64, len(src))
    for i := 0; i < len(src); i++ {
        costs[i] = make([]float64, len(dst))
    }
    matrix := make([][]shipment, len(src))
    for i := 0; i < len(src); i++ {
        matrix[i] = make([]shipment, len(dst))
    }
    for i := 0; i < numSources; i++ {
        for j := 0; j < numDests; j++ {
            scanner.Scan()
            costs[i][j], err = strconv.ParseFloat(scanner.Text(), 64)
            check(err)
        }
    }
    return &transport{filename, src, dst, costs, matrix}
}

func (t *transport) northWestCornerRule() {
    for r, northwest := 0, 0; r < len(t.supply); r++ {
        for c := northwest; c < len(t.demand); c++ {
            quantity := minOf(t.supply[r], t.demand[c])
            if quantity > 0 {
                t.matrix[r][c] = shipment{float64(quantity), t.costs[r][c], r, c}
                t.supply[r] -= quantity
                t.demand[c] -= quantity
                if t.supply[r] == 0 {
                    northwest = c
                    break
                }
            }
        }
    }
}

func (t *transport) steppingStone() {
    maxReduction := 0.0
    var move []shipment = nil
    leaving := shipZero
    t.fixDegenerateCase()
    for r := 0; r < len(t.supply); r++ {
        for c := 0; c < len(t.demand); c++ {
            if t.matrix[r][c] != shipZero {
                continue
            }
            trial := shipment{0, t.costs[r][c], r, c}
            path := t.getClosedPath(trial)
            reduction := 0.0
            lowestQuantity := float64(math.MaxInt32)
            leavingCandidate := shipZero
            plus := true
            for _, s := range path {
                if plus {
                    reduction += s.costPerUnit
                } else {
                    reduction -= s.costPerUnit
                    if s.quantity < lowestQuantity {
                        leavingCandidate = s
                        lowestQuantity = s.quantity
                    }
                }
                plus = !plus
            }
            if reduction < maxReduction {
                move = path
                leaving = leavingCandidate
                maxReduction = reduction
            }
        }
    }

    if move != nil {
        q := leaving.quantity
        plus := true
        for _, s := range move {
            if plus {
                s.quantity += q
            } else {
                s.quantity -= q
            }
            if s.quantity == 0 {
                t.matrix[s.r][s.c] = shipZero
            } else {
                t.matrix[s.r][s.c] = s
            }
            plus = !plus
        }
        t.steppingStone()
    }
}

func (t *transport) matrixToList() *list.List {
    l := list.New()
    for _, m := range t.matrix {
        for _, s := range m {
            if s != shipZero {
                l.PushBack(s)
            }
        }
    }
    return l
}

func (t *transport) getClosedPath(s shipment) []shipment {
    path := t.matrixToList()
    path.PushFront(s)

    // remove (and keep removing) elements that do not have a
    // vertical AND horizontal neighbor
    var next *list.Element
    for {
        removals := 0
        for e := path.Front(); e != nil; e = next {
            next = e.Next()
            nbrs := t.getNeighbors(e.Value.(shipment), path)
            if nbrs[0] == shipZero || nbrs[1] == shipZero {
                path.Remove(e)
                removals++
            }
        }
        if removals == 0 {
            break
        }
    }

    // place the remaining elements in the correct plus-minus order
    stones := make([]shipment, path.Len())
    prev := s
    for i := 0; i < len(stones); i++ {
        stones[i] = prev
        prev = t.getNeighbors(prev, path)[i%2]
    }
    return stones
}

func (t *transport) getNeighbors(s shipment, lst *list.List) [2]shipment {
    var nbrs [2]shipment
    for e := lst.Front(); e != nil; e = e.Next() {
        o := e.Value.(shipment)
        if o != s {
            if o.r == s.r && nbrs[0] == shipZero {
                nbrs[0] = o
            } else if o.c == s.c && nbrs[1] == shipZero {
                nbrs[1] = o
            }
            if nbrs[0] != shipZero && nbrs[1] != shipZero {
                break
            }
        }
    }
    return nbrs
}

func (t *transport) fixDegenerateCase() {
    eps := math.SmallestNonzeroFloat64
    if len(t.supply)+len(t.demand)-1 != t.matrixToList().Len() {
        for r := 0; r < len(t.supply); r++ {
            for c := 0; c < len(t.demand); c++ {
                if t.matrix[r][c] == shipZero {
                    dummy := shipment{eps, t.costs[r][c], r, c}
                    if len(t.getClosedPath(dummy)) == 0 {
                        t.matrix[r][c] = dummy
                        return
                    }
                }
            }
        }
    }
}

func (t *transport) printResult() {
    fmt.Println(t.filename)
    text, err := ioutil.ReadFile(t.filename)
    check(err)
    fmt.Printf("\n%s\n", string(text))
    fmt.Printf("Optimal solution for %s\n\n", t.filename)
    totalCosts := 0.0
    for r := 0; r < len(t.supply); r++ {
        for c := 0; c < len(t.demand); c++ {
            s := t.matrix[r][c]
            if s != shipZero && s.r == r && s.c == c {
                fmt.Printf(" %3d ", int(s.quantity))
                totalCosts += s.quantity * s.costPerUnit
            } else {
                fmt.Printf("  -  ")
            }
        }
        fmt.Println()
    }
    fmt.Printf("\nTotal costs: %g\n\n", totalCosts)
}

func main() {
    filenames := []string{"input1.txt", "input2.txt", "input3.txt"}
    for _, filename := range filenames {
        t := newTransport(filename)
        t.northWestCornerRule()
        t.steppingStone()
        t.printResult()
    }
}
