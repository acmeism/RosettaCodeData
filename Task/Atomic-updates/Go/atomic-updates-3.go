// rwList, rw is for RWMutex-synchronized.
type rwList struct {
    b []int // bucket data specified by task

    // Syncronization objects.
    m   []sync.Mutex // mutex for each bucket
    all sync.RWMutex // mutex for entire list, for snapshot operation

    tc []int // a transfer count for each updater
}

// Constructor.
func newRwList(nBuckets, initialSum, nUpdaters int) *rwList {
    bl := &rwList{
        b:  make([]int, nBuckets),
        m:  make([]sync.Mutex, nBuckets),
        tc: make([]int, nUpdaters),
    }
    for i, dist := nBuckets, initialSum; i > 0; {
        v := dist / i
        i--
        bl.b[i] = v
        dist -= v
    }
    return bl
}

// Four methods implementing the bucketList interface.
func (bl *rwList) bucketValue(b int) int {
    bl.m[b].Lock() // lock on bucket ensures read is atomic
    r := bl.b[b]
    bl.m[b].Unlock()
    return r
}

func (bl *rwList) transfer(b1, b2, a int, ux int) {
    if b1 == b2 { // null operation
        return
    }
    // RLock on list allows other simultaneous transfers.
    bl.all.RLock()
    // Locking lowest bucket first prevents deadlock
    // with multiple tasks working at the same time.
    if b1 < b2 {
        bl.m[b1].Lock()
        bl.m[b2].Lock()
    } else {
        bl.m[b2].Lock()
        bl.m[b1].Lock()
    }
    // clamp
    if a > bl.b[b1] {
        a = bl.b[b1]
    }
    // transfer
    bl.b[b1] -= a
    bl.b[b2] += a
    bl.tc[ux]++ // increment transfer count
    // release
    bl.m[b1].Unlock()
    bl.m[b2].Unlock()
    bl.all.RUnlock()
    // With current Go, the program can hang without a call to gosched here.
    // It seems that functions in the sync package don't touch the scheduler,
    // (which is good) but we need to touch it here to give the channel
    // operations in buddha a chance to run.  (The current Go scheduler
    // is basically cooperative rather than preemptive.)
    runtime.Gosched()
}

func (bl *rwList) snapshot(s []int, tc []int) {
    bl.all.Lock() // RW lock on list prevents transfers during snap.
    copy(s, bl.b)
    copy(tc, bl.tc)
    for i := range bl.tc {
        bl.tc[i] = 0
    }
    bl.all.Unlock()
}

func (bl *rwList) buckets() int {
    return len(bl.b)
}
