package main

import (
    "fmt"
    "math/rand"
    "time"
)

// Data type required by task.
type bucketList interface {
    // Two operations required by task.  Updater parameter not specified
    // by task, but useful for displaying update counts as an indication
    // that transfer operations are happening "as often as possible."
    bucketValue(bucket int) int
    transfer(b1, b2, ammount, updater int)

    // Operation not specified by task, but needed for synchronization.
    snapshot(bucketValues []int, transferCounts []int)

    // Operation not specified by task, but useful.
    buckets() int // number of buckets
}

// Total of all bucket values, declared as a const to demonstrate that
// it doesn't change.
const originalTotal = 1000

// Updater ids, used for maintaining transfer counts.
const (
    idOrder = iota
    idChaos
    nUpdaters
)

func main() {
    // Create a concrete object implementing the bucketList interface.
    bl := newChList(10, originalTotal, nUpdaters)

    // Three concurrent tasks.
    go order(bl)
    go chaos(bl)
    buddha(bl)
}

// The concurrent tasks exercise the data operations by going through
// the bucketList interface.  They do no explicit synchronization and
// are not responsible for maintaining invariants.

// Exercise (1.) required by task: make values more equal.
func order(bl bucketList) {
    r := rand.New(rand.NewSource(time.Now().UnixNano()))
    nBuckets := bl.buckets()
    for {
        b1 := r.Intn(nBuckets)
        b2 := r.Intn(nBuckets)
        v1 := bl.bucketValue(b1)
        v2 := bl.bucketValue(b2)
        if v1 > v2 {
            bl.transfer(b1, b2, (v1-v2)/2, idOrder)
        } else {
            bl.transfer(b2, b1, (v2-v1)/2, idOrder)
        }
    }
}

// Exercise (2.) required by task: redistribute values.
func chaos(bl bucketList) {
    r := rand.New(rand.NewSource(time.Now().UnixNano()))
    nBuckets := bl.buckets()
    for {
        b1 := r.Intn(nBuckets)
        b2 := r.Intn(nBuckets)
        bl.transfer(b1, b2, r.Intn(bl.bucketValue(b1)+1), idChaos)
    }
}

// Exercise (3.) requred by task: display total.
func buddha(bl bucketList) {
    nBuckets := bl.buckets()
    s := make([]int, nBuckets)
    tc := make([]int, nUpdaters)
    var total, nTicks int

    fmt.Println("sum  ---updates---    mean  buckets")
    tr := time.Tick(time.Second / 10)
    for {
        var sum int
        <-tr
        bl.snapshot(s, tc)
        for _, l := range s {
            if l < 0 {
                panic("sob") // invariant not preserved
            }
            sum += l
        }
        // Output number of updates per tick and cummulative mean
        // updates per tick to demonstrate "as often as possible"
        // of task exercises 1 and 2.
        total += tc[0] + tc[1]
        nTicks++
        fmt.Printf("%d %6d %6d %7d  %v\n", sum, tc[0], tc[1], total/nTicks, s)
        if sum != originalTotal {
            panic("weep") // invariant not preserved
        }
    }
}
