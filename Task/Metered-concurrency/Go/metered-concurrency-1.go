package main

import (
    "log"
    "os"
    "sync"
    "time"
)

// log package serializes output
var fmt = log.New(os.Stdout, "", 0)

// library analogy per WP article
const nRooms = 10
const nStudents = 20

func main() {
    // buffered channel used as a counting semaphore
    rooms := make(chan int, nRooms)
    for i := 0; i < nRooms; i++ {
        rooms <- 1
    }
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

func student(rooms chan int, studied *sync.WaitGroup) {
    <-rooms         // acquire operation
    // report per task descrption.  also exercise count operation
    fmt.Printf("Room entered.  Count is %d.  Studying...\n",
        len(rooms)) // len function provides count operation
    time.Sleep(2 * time.Second) // sleep per task description
    rooms <- 1      // release operation
    studied.Done()  // signal that student is done
}
