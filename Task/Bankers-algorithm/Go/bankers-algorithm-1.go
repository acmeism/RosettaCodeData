package bank

import (
    "bytes"
    "errors"
    "fmt"
    "log"
    "sort"
    "sync"
)

type PID string
type RID string
type RMap map[RID]int

// format RIDs in order
func (m RMap) String() string {
    rs := make([]string, len(m))
    i := 0
    for r := range m {
        rs[i] = string(r)
        i++
    }
    sort.Strings(rs)
    var b bytes.Buffer
    b.WriteString("{")
    for _, r := range rs {
        fmt.Fprintf(&b, "%q: %d, ", r, m[RID(r)])
    }
    bb := b.Bytes()
    if len(bb) > 1 {
        bb[len(bb)-2] = '}'
    }
    return string(bb)
}

type Bank struct {
    available  RMap
    max        map[PID]RMap
    allocation map[PID]RMap
    sync.Mutex
}

func (b *Bank) need(p PID, r RID) int {
    return b.max[p][r] - b.allocation[p][r]
}

func New(available RMap) (b *Bank, err error) {
    for r, a := range available {
        if a < 0 {
            return nil, fmt.Errorf("negative resource %s: %d", r, a)
        }
    }
    return &Bank{
        available:  available,
        max:        map[PID]RMap{},
        allocation: map[PID]RMap{},
    }, nil
}

func (b *Bank) NewProcess(p PID, max RMap) (err error) {
    b.Lock()
    defer b.Unlock()
    if _, ok := b.max[p]; ok {
        return fmt.Errorf("process %s already registered", p)
    }
    for r, m := range max {
        switch a, ok := b.available[r]; {
        case !ok:
            return fmt.Errorf("resource %s unknown", r)
        case m > a:
            return fmt.Errorf("resource %s: process %s max %d > available %d",
                r, p, m, a)
        }
    }
    b.max[p] = max
    b.allocation[p] = RMap{}
    return
}

func (b *Bank) Request(pid PID, change RMap) (err error) {
    b.Lock()
    defer b.Unlock()
    if _, ok := b.max[pid]; !ok {
        return fmt.Errorf("process %s unknown", pid)
    }
    for r, c := range change {
        if c < 0 {
            return errors.New("decrease not allowed")
        }
        if _, ok := b.available[r]; !ok {
            return fmt.Errorf("resource %s unknown", r)
        }
        if c > b.need(pid, r) {
            return errors.New("increase exceeds declared max")
        }
    }
    // allocation is non-exported data so we can change it in place
    // then change it back if the request cannot be granted.
    for r, c := range change {
        b.allocation[pid][r] += c // change in place
    }
    defer func() {
        if err != nil { // if request not granted,
            for r, c := range change {
                b.allocation[pid][r] -= c // change it back
            }
        }
    }()
    // Collect list of process IDs, also compute cash
    // First in the list is always the requesting PID.
    cash := RMap{}
    for r, a := range b.available {
        cash[r] = a
    }
    perm := make([]PID, len(b.allocation))
    i := 1
    for pr, a := range b.allocation {
        if pr == pid {
            perm[0] = pr
        } else {
            perm[i] = pr
            i++
        }
        for r, a := range a {
            cash[r] -= a
        }
    }
    ret := RMap{}  // sum of loans
    m := len(perm) // number of processes still candidates for termination
    for {
        // find a process h that can terminate
        h := 0
    h:
        for ; ; h++ {
            if h == m {
                // no process could terminate
                return errors.New("request would make deadlock possible")
            }
            for r := range b.available {
                if b.need(perm[h], r) > cash[r]+ret[r] {
                    // h cannot terminate if any resource need cannot be met.
                    continue h
                }
            }
            // log possible terimation, consistent with WP example program.
            log.Println(" ", perm[h], "could terminate")
            // all resource needs can be met.  h can terminate.
            break
        }
        if h == 0 { // Zwanenburg condition:
            // if requesting process can terminate, pattern is safe and
            // remaining terminations do not need to be demonstrated.
            return nil
        }
        for r, a := range b.allocation[perm[h]] {
            ret[r] += a
        }
        m--
        perm[h] = perm[m]
    }
}
