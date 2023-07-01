package main

import (
    "fmt"
    "log"
    "math"
    "os"
    "path/filepath"
)

func commatize(n int64) string {
    s := fmt.Sprintf("%d", n)
    if n < 0 {
        s = s[1:]
    }
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    if n >= 0 {
        return s
    }
    return "-" + s
}

func fileSizeDistribution(root string) {
    var sizes [12]int
    files := 0
    directories := 0
    totalSize := int64(0)
    walkFunc := func(path string, info os.FileInfo, err error) error {
        if err != nil {
            return err
        }
        files++
        if info.IsDir() {
            directories++
        }
        size := info.Size()
        if size == 0 {
            sizes[0]++
            return nil
        }
        totalSize += size
        logSize := math.Log10(float64(size))
        index := int(math.Floor(logSize))
        sizes[index+1]++
        return nil
    }
    err := filepath.Walk(root, walkFunc)
    if err != nil {
        log.Fatal(err)
    }
    fmt.Printf("File size distribution for '%s' :-\n\n", root)
    for i := 0; i < len(sizes); i++ {
        if i == 0 {
            fmt.Print("  ")
        } else {
            fmt.Print("+ ")
        }
        fmt.Printf("Files less than 10 ^ %-2d bytes : %5d\n", i, sizes[i])
    }
    fmt.Println("                                  -----")
    fmt.Printf("= Total number of files         : %5d\n", files)
    fmt.Printf("  including directories         : %5d\n", directories)
    c := commatize(totalSize)
    fmt.Println("\n  Total size of files           :", c, "bytes")
}

func main() {
    fileSizeDistribution("./")
}
