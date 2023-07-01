package main

import (
    "log"
    "os"
    "sync"
    "time"
)

// counting semaphore implemented with a buffered channel
type sem chan struct{}

func (s sem) acquire()   { s <- struct{}{} }
func (s sem) release()   { <-s }
func (s sem) count() int { return cap(s) - len(s) }

// log package serializes output
var fmt = log.New(os.Stdout, "", 0)

// library analogy per WP article
const nRooms = 10
const nStudents = 20

func main() {
    rooms := make(sem, nRooms)
    // WaitGroup used to wait for all students to have studied
    // before terminating program
    var studied sync.WaitGroup
    studied.Add(nStudents)
    // nStudents run concurrently
    for i := 0; i < nStudents; i++ {
        go student(rooms, &studied)
    }
    studied.Wait()
}

func student(rooms sem, studied *sync.WaitGroup) {
    rooms.acquire()
    // report per task descrption.  also exercise count operation
    fmt.Printf("Room entered.  Count is %d.  Studying...\n",
        rooms.count())
    time.Sleep(2 * time.Second) // sleep per task description
    rooms.release()
    studied.Done() // signal that student is done
}
