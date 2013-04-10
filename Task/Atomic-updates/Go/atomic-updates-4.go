// lf for lock-free
type lfList struct {
    b []int32
    sync.RWMutex
    tc []int
}

// Constructor.
func newLfList(nBuckets, initialSum, nUpdaters int) *lfList {
    bl := &lfList{
        b:  make([]int32, nBuckets),
        tc: make([]int, nUpdaters),
    }
    for i, dist := int32(nBuckets), int32(initialSum); i > 0; {
        v := dist / i
        i--
        bl.b[i] = v
        dist -= v
    }
    return bl
}

// Four methods implementing the bucketList interface.
func (bl *lfList) bucketValue(b int) int {
    return int(atomic.LoadInt32(&bl.b[b]))
}

func (bl *lfList) transfer(b1, b2, a int, ux int) {
    if b1 == b2 {
        return
    }
    bl.RLock()
    for {
        t := int32(a)
        v1 := atomic.LoadInt32(&bl.b[b1])
        if t > v1 {
            t = v1
        }
        if atomic.CompareAndSwapInt32(&bl.b[b1], v1, v1-t) {
            atomic.AddInt32(&bl.b[b2], t)
            break
        }
        // else retry
    }
    bl.tc[ux]++
    bl.RUnlock()
    runtime.Gosched()
}

func (bl *lfList) snapshot(s []int, tc []int) {
    bl.Lock()
    for i, bv := range bl.b {
        s[i] = int(bv)
    }
    for i := range bl.tc {
        tc[i], bl.tc[i] = bl.tc[i], 0
    }
    bl.Unlock()
}

func (bl *lfList) buckets() int {
    return len(bl.b)
}
