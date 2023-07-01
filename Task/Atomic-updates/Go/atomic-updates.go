package main

import (
    "fmt"
    "math/rand"
    "sync"
    "time"
)

const nBuckets = 10

type bucketList struct {
    b [nBuckets]int // bucket data specified by task

    // transfer counts for each updater, not strictly required by task but
    // useful to show that the two updaters get fair chances to run.
    tc [2]int

    sync.Mutex // synchronization
}

// Updater ids, to track number of transfers by updater.
// these can index bucketlist.tc for example.
const (
    idOrder = iota
    idChaos
)

const initialSum = 1000 // sum of all bucket values

// Constructor.
func newBucketList() *bucketList {
    var bl bucketList
    // Distribute initialSum across buckets.
    for i, dist := nBuckets, initialSum; i > 0; {
        v := dist / i
        i--
        bl.b[i] = v
        dist -= v
    }
    return &bl
}

// method 1 required by task, get current value of a bucket
func (bl *bucketList) bucketValue(b int) int {
    bl.Lock() // lock before accessing data
    r := bl.b[b]
    bl.Unlock()
    return r
}

// method 2 required by task
func (bl *bucketList) transfer(b1, b2, a int, ux int) {
    // Get access.
    bl.Lock()
    // Clamping maintains invariant that bucket values remain nonnegative.
    if a > bl.b[b1] {
        a = bl.b[b1]
    }
    // Transfer.
    bl.b[b1] -= a
    bl.b[b2] += a
    bl.tc[ux]++ // increment transfer count
    bl.Unlock()
}

// additional useful method
func (bl *bucketList) snapshot(s *[nBuckets]int, tc *[2]int) {
    bl.Lock()
    *s = bl.b
    *tc = bl.tc
    bl.tc = [2]int{} // clear transfer counts
    bl.Unlock()
}

var bl = newBucketList()

func main() {
    // Three concurrent tasks.
    go order() // make values closer to equal
    go chaos() // arbitrarily redistribute values
    buddha()   // display total value and individual values of each bucket
}

// The concurrent tasks exercise the data operations by calling bucketList
// methods.  The bucketList methods are "threadsafe", by which we really mean
// goroutine-safe.  The conconcurrent tasks then do no explicit synchronization
// and are not responsible for maintaining invariants.

// Exercise 1 required by task: make values more equal.
func order() {
    r := rand.New(rand.NewSource(time.Now().UnixNano()))
    for {
        b1 := r.Intn(nBuckets)
        b2 := r.Intn(nBuckets - 1)
        if b2 >= b1 {
            b2++
        }
        v1 := bl.bucketValue(b1)
        v2 := bl.bucketValue(b2)
        if v1 > v2 {
            bl.transfer(b1, b2, (v1-v2)/2, idOrder)
        } else {
            bl.transfer(b2, b1, (v2-v1)/2, idOrder)
        }
    }
}

// Exercise 2 required by task: redistribute values.
func chaos() {
    r := rand.New(rand.NewSource(time.Now().Unix()))
    for {
        b1 := r.Intn(nBuckets)
        b2 := r.Intn(nBuckets - 1)
        if b2 >= b1 {
            b2++
        }
        bl.transfer(b1, b2, r.Intn(bl.bucketValue(b1)+1), idChaos)
    }
}

// Exercise 3 requred by task: display total.
func buddha() {
    var s [nBuckets]int
    var tc [2]int
    var total, nTicks int

    fmt.Println("sum  ---updates---    mean  buckets")
    tr := time.Tick(time.Second / 10)
    for {
        <-tr
        bl.snapshot(&s, &tc)
        var sum int
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
        fmt.Printf("%d %6d %6d %7d  %3d\n", sum, tc[0], tc[1], total/nTicks, s)
        if sum != initialSum {
            panic("weep") // invariant not preserved
        }
    }
}
