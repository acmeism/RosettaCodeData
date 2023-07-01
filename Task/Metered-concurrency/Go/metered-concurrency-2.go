package main

import (
    "log"
    "os"
    "sync"
    "time"
)

var fmt = log.New(os.Stdout, "", 0)

type countSem struct {
    int
    sync.Cond
}

func newCount(n int) *countSem {
    return &countSem{n, sync.Cond{L: &sync.Mutex{}}}
}

func (cs *countSem) count() int {
    cs.L.Lock()
    c := cs.int
    cs.L.Unlock()
    return c
}

func (cs *countSem) acquire() {
    cs.L.Lock()
    cs.int--
    for cs.int < 0 {
        cs.Wait()
    }
    cs.L.Unlock()
}

func (cs *countSem) release() {
    cs.L.Lock()
    cs.int++
    cs.L.Unlock()
    cs.Broadcast()
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
