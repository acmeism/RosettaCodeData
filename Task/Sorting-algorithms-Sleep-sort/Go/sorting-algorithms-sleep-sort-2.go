package main

import (
        "fmt"
        "log"
        "os"
        "strconv"
        "sync"
        "time"
)

func main() {
        var wg sync.WaitGroup
        wg.Add(len(os.Args[1:]))
        for _,i := range os.Args[1:] {
                x, err := strconv.ParseUint(i, 10, 64)
                if err != nil {
                        log.Println(err)
                }
                wg.Add(1)
                go func(i uint64, wg *sync.WaitGroup) {
                        defer wg.Done()
                        time.Sleep(time.Duration(i) * time.Second)
                        fmt.Println(i)
                }(x, &wg)
        }
        wg.Wait()
}
