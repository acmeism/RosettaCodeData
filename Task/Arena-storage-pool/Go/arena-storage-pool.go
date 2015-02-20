package main

import (
    "fmt"
    "runtime"
    "sync"
)

// New to Go 1.3 are sync.Pools, basically goroutine-safe free lists.
// There is overhead in the goroutine-safety and if you do not need this
// you might do better by implementing your own free list.

func main() {
    // Task 1:  Define a pool (of ints).  Just as the task says, a sync.Pool
    // allocates individually and can free as a group.
    p := sync.Pool{New: func() interface{} {
        fmt.Println("pool empty")
        return new(int)
    }}
    // Task 2: Allocate some ints.
    i := new(int)
    j := new(int)
    // Show that they're usable.
    *i = 1
    *j = 2
    fmt.Println(*i + *j) // prints 3
    // Task 2 continued:  Put allocated ints in pool p.
    // Task explanation:  Variable p has a pool as its value.  Another pool
    // could be be created and assigned to a different variable.  You choose
    // a pool simply by using the appropriate variable, p here.
    p.Put(i)
    p.Put(j)
    // Drop references to i and j.  This allows them to be garbage collected;
    // that is, freed as a group.
    i = nil
    j = nil
    // Get ints for i and j again, this time from the pool.  P.Get may reuse
    // an object allocated above as long as objects haven't been garbage
    // collected yet; otherwise p.Get will allocate a new object.
    i = p.Get().(*int)
    j = p.Get().(*int)
    *i = 4
    *j = 5
    fmt.Println(*i + *j) // prints 9
    // One more test, this time forcing a garbage collection.
    p.Put(i)
    p.Put(j)
    i = nil
    j = nil
    runtime.GC()
    i = p.Get().(*int)
    j = p.Get().(*int)
    *i = 7
    *j = 8
    fmt.Println(*i + *j) // prints 15
}
