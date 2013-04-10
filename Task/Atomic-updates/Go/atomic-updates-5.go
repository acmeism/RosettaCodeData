// mnList (mn for monitor-synchronized) is a concrete type implementing
// the bucketList interface.  The monitor is a goroutine, all communication
// with it is done through channels, which are the members of mnList.
// All data implementing the buckets is encapsulated in the monitor.
type mnList struct {
    vrCh chan *valueReq
    trCh chan *transferReq
    srCh chan *snapReq
    nbCh chan chan int
}

// Constructor makes channels and starts monitor.
func newMnList(nBuckets, initialSum, nUpdaters int) *mnList {
    mn := &mnList{
        make(chan *valueReq),
        make(chan *transferReq),
        make(chan *snapReq),
        make(chan chan int),
    }
    go monitor(mn, nBuckets, initialSum, nUpdaters)
    return mn
}

// Monitor goroutine ecapsulates data and enters a loop to handle requests.
// The loop handles one request at a time, thus serializing all access.
func monitor(mn *mnList, nBuckets, initialSum, nUpdaters int) {
    // bucket representation
    b := make([]int, nBuckets)
    for i, dist := nBuckets, initialSum; i > 0; {
        v := dist / i
        i--
        b[i] = v
        dist -= v
    }
    // transfer count representation
    count := make([]int, nUpdaters)

    // monitor loop
    for {
        select {
        // value request operation
        case vr := <-mn.vrCh:
            vr.resp <- b[vr.bucket]

        // transfer operation
        case tr := <-mn.trCh:
            // clamp
            if tr.amount > b[tr.from] {
                tr.amount = b[tr.from]
            }
            // transfer
            b[tr.from] -= tr.amount
            b[tr.to] += tr.amount
            count[tr.updaterId]++

        // snap operation
        case sr := <-mn.srCh:
            copy(sr.bucketSnap, b)
            copy(sr.countSnap, count)
            for i := range count {
                count[i] = 0
            }
            sr.resp <- true

        // number of buckets
        case nb := <-mn.nbCh:
            nb <- nBuckets
        }
    }
}

type valueReq struct {
    bucket int
    resp   chan int
}

func (mn *mnList) bucketValue(b int) int {
    resp := make(chan int)
    mn.vrCh <- &valueReq{b, resp}
    return <-resp
}

type transferReq struct {
    from, to  int
    amount    int
    updaterId int
}

func (mn *mnList) transfer(b1, b2, a, ux int) {
    mn.trCh <- &transferReq{b1, b2, a, ux}
}

type snapReq struct {
    bucketSnap []int
    countSnap  []int
    resp       chan bool
}

func (mn *mnList) snapshot(s []int, tc []int) {
    resp := make(chan bool)
    mn.srCh <- &snapReq{s, tc, resp}
    <-resp
}

func (mn *mnList) buckets() int {
    resp := make(chan int)
    mn.nbCh <- resp
    return <-resp
}
