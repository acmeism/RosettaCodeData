package main

import (
    "fmt"
    "runtime"
    "time"
)

const problem = true

func main() {
    fmt.Println("main program start")

    // this will get run on exit
    defer paperwork()

    // this will not run to completion
    go pcj()

    // this will not get run on exit
    rec := &requiresExternalCleanup{"external object"}
    runtime.SetFinalizer(rec, cleanup)

    if problem {
        fmt.Println("main program returning")
        return
    }
}

func paperwork() {
    fmt.Println("i's dotted, t's crossed")
}

func pcj() {
    fmt.Println("there's uncle Joe")
    time.Sleep(1e10)
    fmt.Println("movin kinda slow")
}

type requiresExternalCleanup struct {
    id string
}

func cleanup(rec *requiresExternalCleanup) {
    fmt.Println(rec.id, "cleanup")
}
