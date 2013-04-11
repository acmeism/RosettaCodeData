package main

import (
    "log"
    "os"
    "sync"
    "time"
)

var fmt = log.New(os.Stdout, "", 0)

func main() {
    // three operations per task description
    acquire := make(chan int)
    release := make(chan int)
    count := make(chan chan int)

    // library analogy per WP article
    go librarian(acquire, release, count, 10)
    nStudents := 20
    var studied sync.WaitGroup
    studied.Add(nStudents)
    for i := 0; i < nStudents; i++ {
        go student(acquire, release, count, &studied)
    }
    // wait until all students have studied before terminating program
    studied.Wait()
}

func librarian(a, r chan int, c chan chan int, count int) {
    p := a // acquire operation is served or not depending on count
    for {
        select {
        case <-p:       // acquire/p/wait operation
            count--
            if count == 0 {
                p = nil
            }
        case <-r:       // release/v operation
            count++
            p = a
        case cc := <-c: // count operation
            cc <- count
        }
    }
}

func student(a, r chan int, c chan chan int, studied *sync.WaitGroup) {
    cc := make(chan int)
    a <- 0                      // acquire
    c <- cc                     // request count
    fmt.Printf("Room entered.  Count is %d.  Studying...\n", <-cc)
    time.Sleep(2 * time.Second) // sleep per task description
    r <- 0                      // release
    studied.Done()              // signal done
}
