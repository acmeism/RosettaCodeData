// chList (ch for channel-synchronized) is a concrete type implementing
// the bucketList interface.  The bucketList interface declared methods,
// the struct type here declares data.  chList methods are repsonsible
// for synchronization so they are goroutine-safe.  They are also
// responsible for maintaining the invariants that the sum of all buckets
// stays constant and that no bucket value goes negative.
type chList struct {
    b  []int     // bucket data specified by task
    s  chan bool // syncronization object
    tc []int     // a transfer count for each updater
}

// Constructor.
func newChList(nBuckets, initialSum, nUpdaters int) *chList {
    bl := &chList{
        b:  make([]int, nBuckets),
        s:  make(chan bool, 1),
        tc: make([]int, nUpdaters),
    }
    // Distribute initialSum across buckets.
    for i, dist := nBuckets, initialSum; i > 0; {
        v := dist / i
        i--
        bl.b[i] = v
        dist -= v
    }
    // Synchronization is needed to maintain the invariant that the total
    // of all bucket values stays the same.  This is an implementation of
    // the straightforward solution mentioned in the task description,
    // ensuring that only one transfer happens at a time.  Channel s
    // holds a token.  All methods must take the token from the channel
    // before accessing data and then return the token when they are done.
    // it is equivalent to a mutex.  The constructor makes data available
    // by initially dropping the token in the channel after all data is
    // initialized.
    bl.s <- true
    return bl
}

// Four methods implementing the bucketList interface.
func (bl *chList) bucketValue(b int) int {
    <-bl.s // get token before accessing data
    r := bl.b[b]
    bl.s <- true // return token
    return r
}

func (bl *chList) transfer(b1, b2, a int, ux int) {
    if b1 == b2 { // null operation
        return
    }
    // Get access.
    <-bl.s
    // Clamping maintains invariant that bucket values remain nonnegative.
    if a > bl.b[b1] {
        a = bl.b[b1]
    }
    // Transfer.
    bl.b[b1] -= a
    bl.b[b2] += a
    bl.tc[ux]++ // increment transfer count
    // Release "lock".
    bl.s <- true
}

func (bl *chList) snapshot(s []int, tc []int) {
    <-bl.s
    copy(s, bl.b)
    copy(tc, bl.tc)
    for i := range bl.tc {
        bl.tc[i] = 0
    }
    bl.s <- true
}

func (bl *chList) buckets() int {
    return len(bl.b)
}
