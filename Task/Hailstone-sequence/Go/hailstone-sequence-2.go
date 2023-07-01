package main

import "fmt"

// Task 1 implemented with a generator.  Calling newHg will "create
// a routine to generate the hailstone sequence for a number."
func newHg(n int) func() int {
    return func() (n0 int) {
        n0 = n
        if n&1 == 0 {
            n = n / 2
        } else {
            n = 3*n + 1
        }
        return
    }
}

func main() {
    // make generator for sequence starting at 27
    hg := newHg(27)
    // save first four elements for printing later
    s1, s2, s3, s4 := hg(), hg(), hg(), hg()
    // load next four elements in variables to use as shift register.
    e4, e3, e2, e1 := hg(), hg(), hg(), hg()
    // 4+4= 8 that we've generated so far
    ec := 8
    // until we get to 1, generate another value, shift, and increment.
    // note that intermediate elements--those shifted off--are not saved.
    for e1 > 1 {
        e4, e3, e2, e1 = e3, e2, e1, hg()
        ec++
    }
    // Complete task 2:
    fmt.Printf("hs(27): %d elements: [%d %d %d %d ... %d %d %d %d]\n",
        ec, s1, s2, s3, s4, e4, e3, e2, e1)

    // Task 3:  strategy is to not store sequences, but just the length
    // of each sequence.  as soon as the sequence we're currently working on
    // dips into the range that we've already computed, we short-circuit
    // to the end by adding the that known length to whatever length
    // we've accumulated so far.

    var nMaxLen int // variable holds n with max length encounted so far
    // slice holds sequence length for each n as it is computed
    var computedLen [1e5]int
    computedLen[1] = 1
    for n := 2; n < 1e5; n++ {
        var ele, lSum int
        for hg := newHg(n); ; lSum++ {
            ele = hg()
            // as soon as we get an element in the range we have already
            // computed, we're done...
            if ele < n {
                break
            }
        }
        // just add the sequence length already computed from this point.
        lSum += computedLen[ele]
        // save the sequence length for this n
        computedLen[n] = lSum
        // and note if it's the maximum so far
        if lSum > computedLen[nMaxLen] {
            nMaxLen = n
        }
    }
    fmt.Printf("hs(%d): %d elements\n", nMaxLen, computedLen[nMaxLen])
}
