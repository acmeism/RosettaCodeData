package main

import (
    "fmt"
    "io"
    "log"
    "math"
    "math/rand"
    "os"
    "time"
)

type MinHeapNode struct{ element, index int }

type MinHeap struct{ nodes []MinHeapNode }

func left(i int) int {
    return (2*i + 1)
}

func right(i int) int {
    return (2*i + 2)
}

func newMinHeap(nodes []MinHeapNode) *MinHeap {
    mh := new(MinHeap)
    mh.nodes = nodes
    for i := (len(nodes) - 1) / 2; i >= 0; i-- {
        mh.minHeapify(i)
    }
    return mh
}

func (mh *MinHeap) getMin() MinHeapNode {
    return mh.nodes[0]
}

func (mh *MinHeap) replaceMin(x MinHeapNode) {
    mh.nodes[0] = x
    mh.minHeapify(0)
}

func (mh *MinHeap) minHeapify(i int) {
    l, r := left(i), right(i)
    smallest := i
    heapSize := len(mh.nodes)
    if l < heapSize && mh.nodes[l].element < mh.nodes[i].element {
        smallest = l
    }
    if r < heapSize && mh.nodes[r].element < mh.nodes[smallest].element {
        smallest = r
    }
    if smallest != i {
        mh.nodes[i], mh.nodes[smallest] = mh.nodes[smallest], mh.nodes[i]
        mh.minHeapify(smallest)
    }
}

func merge(arr []int, l, m, r int) {
    n1, n2 := m-l+1, r-m
    tl := make([]int, n1)
    tr := make([]int, n2)
    copy(tl, arr[l:])
    copy(tr, arr[m+1:])
    i, j, k := 0, 0, l
    for i < n1 && j < n2 {
        if tl[i] <= tr[j] {
            arr[k] = tl[i]
            k++
            i++
        } else {
            arr[k] = tr[j]
            k++
            j++
        }
    }
    for i < n1 {
        arr[k] = tl[i]
        k++
        i++
    }
    for j < n2 {
        arr[k] = tr[j]
        k++
        j++
    }
}

func mergeSort(arr []int, l, r int) {
    if l < r {
        m := l + (r-l)/2
        mergeSort(arr, l, m)
        mergeSort(arr, m+1, r)
        merge(arr, l, m, r)
    }
}

// Merge k sorted files: es0,es1 etc.
func mergeFiles(outputFile string, n, k int) {
    in := make([]*os.File, k)
    var err error
    for i := 0; i < k; i++ {
        fileName := fmt.Sprintf("es%d", i)
        in[i], err = os.Open(fileName)
        check(err)
    }
    out, err := os.Create(outputFile)
    check(err)
    nodes := make([]MinHeapNode, k)
    i := 0
    for ; i < k; i++ {
        _, err = fmt.Fscanf(in[i], "%d", &nodes[i].element)
        if err == io.EOF {
            break
        }
        check(err)
        nodes[i].index = i
    }
    hp := newMinHeap(nodes[:i])
    count := 0
    for count != i {
        root := hp.getMin()
        fmt.Fprintf(out, "%d ", root.element)
        _, err = fmt.Fscanf(in[root.index], "%d", &root.element)
        if err == io.EOF {
            root.element = math.MaxInt32
            count++
        } else {
            check(err)
        }
        hp.replaceMin(root)
    }
    for j := 0; j < k; j++ {
        in[j].Close()
    }
    out.Close()
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

// Create initial runs, divide them evenly amongst the output files
// and then merge-sort them.
func createInitialRuns(inputFile string, runSize, numWays int) {
    in, err := os.Open(inputFile)
    out := make([]*os.File, numWays)
    for i := 0; i < numWays; i++ {
        fileName := fmt.Sprintf("es%d", i) // es0, es1 etc.
        out[i], err = os.Create(fileName)
        check(err)
    }
    arr := make([]int, runSize)
    moreInput := true
    nextOutputFile := 0
    var i int
    for moreInput {
        for i = 0; i < runSize; i++ {
            _, err := fmt.Fscanf(in, "%d", &arr[i])
            if err == io.EOF {
                moreInput = false
                break
            }
            check(err)
        }
        mergeSort(arr, 0, i-1)
        for j := 0; j < i; j++ {
            fmt.Fprintf(out[nextOutputFile], "%d ", arr[j])
        }
        nextOutputFile++
    }
    for j := 0; j < numWays; j++ {
        out[j].Close()
    }
    in.Close()
}

func externalSort(inputFile, outputFile string, numWays, runSize int) {
    createInitialRuns(inputFile, runSize, numWays)
    mergeFiles(outputFile, runSize, numWays)
}

func main() {
    // Create a small test file of 40 random ints and split it into 4 files
    // of 10 integers each.
    numWays := 4
    runSize := 10
    inputFile := "input.txt"
    outputFile := "output.txt"
    in, err := os.Create(inputFile)
    check(err)
    rand.Seed(time.Now().UnixNano())
    for i := 0; i < numWays*runSize; i++ {
        fmt.Fprintf(in, "%d ", rand.Intn(math.MaxInt32))
    }
    in.Close()
    externalSort(inputFile, outputFile, numWays, runSize)
    // remove temporary files
    for i := 0; i < numWays; i++ {
        fileName := fmt.Sprintf("es%d", i)
        err = os.Remove(fileName)
        check(err)
    }
}
