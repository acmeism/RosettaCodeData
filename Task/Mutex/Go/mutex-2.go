package main

import (
    "fmt"
    "time"
)

var value int

func slowInc(ch, done chan bool) {
    // channel receive, used here to implement mutex lock.
    // it will block until a value is available on the channel
    <-ch

    // same as above
    v := value
    time.Sleep(1e8)
    value = v + 1

    // channel send, equivalent to mutex unlock.
    // makes a value available on channel
    ch <- true

    // channels can be used to signal completion too
    done <- true
}

func main() {
    ch := make(chan bool, 1) // ch used as a mutex
    done := make(chan bool)  // another channel used to signal completion
    go slowInc(ch, done)
    go slowInc(ch, done)
    // a freshly created sync.Mutex starts out unlocked, but a freshly created
    // channel is empty, which for us represents "locked."  sending a value on
    // the channel puts the value up for grabs, thus representing "unlocked."
    ch <- true
    <-done
    <-done
    fmt.Println(value)
}
