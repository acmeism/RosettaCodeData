package main

import (
    "log"
    "os"
    "sync"
    "sync/atomic"
    "time"
)

var fmt = log.New(os.Stdout, "", 0)

type countSem struct {
    c    int32
    cond *sync.Cond
}

func newCount(n int) *countSem {
    return &countSem{int32(n), sync.NewCond(new(sync.Mutex))}
}

func (cs *countSem) count() int {
    return int(atomic.LoadInt32(&cs.c))
}

func (cs *countSem) acquire() {
    if atomic.AddInt32(&cs.c, -1) < 0 {
        atomic.AddInt32(&cs.c, 1)
        cs.cond.L.Lock()
        for atomic.AddInt32(&cs.c, -1) < 0 {
            atomic.AddInt32(&cs.c, 1)
            cs.cond.Wait()
        }
        cs.cond.L.Unlock()
    }
}

func (cs *countSem) release() {
    atomic.AddInt32(&cs.c, 1)
    cs.cond.Signal()
}

func main() {
    librarian := newCount(10)
    nStudents := 20
    var studied sync.WaitGroup
    studied.Add(nStudents)
    for i := 0; i < nStudents; i++ {
        go student(librarian, &studied)
    }
    studied.Wait()
}

func student(studyRoom *countSem, studied *sync.WaitGroup) {
    studyRoom.acquire()
    fmt.Printf("Room entered.  Count is %d.  Studying...\n", studyRoom.count())
    time.Sleep(2 * time.Second)
    studyRoom.release()
    studied.Done()
}
