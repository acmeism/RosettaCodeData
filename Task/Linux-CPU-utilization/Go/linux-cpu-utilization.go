package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "strconv"
    "strings"
    "time"
)

func main() {
    fmt.Println("CPU usage % at 1 second intervals:\n")
    var prevIdleTime, prevTotalTime uint64
    for i := 0; i < 10; i++ {
        file, err := os.Open("/proc/stat")
        if err != nil {
            log.Fatal(err)
        }
        scanner := bufio.NewScanner(file)
        scanner.Scan()
        firstLine := scanner.Text()[5:] // get rid of cpu plus 2 spaces
        file.Close()
        if err := scanner.Err(); err != nil {
            log.Fatal(err)
        }
        split := strings.Fields(firstLine)
        idleTime, _ := strconv.ParseUint(split[3], 10, 64)
        totalTime := uint64(0)
        for _, s := range split {
            u, _ := strconv.ParseUint(s, 10, 64)
            totalTime += u
        }
        if i > 0 {
            deltaIdleTime := idleTime - prevIdleTime
            deltaTotalTime := totalTime - prevTotalTime
            cpuUsage := (1.0 - float64(deltaIdleTime)/float64(deltaTotalTime)) * 100.0
            fmt.Printf("%d : %6.3f\n", i, cpuUsage)
        }
        prevIdleTime = idleTime
        prevTotalTime = totalTime
        time.Sleep(time.Second)
    }
}
