package main

import (
    "fmt"
    "crypto/md5"
    "io/ioutil"
    "log"
    "os"
    "path/filepath"
    "sort"
    "time"
)

type fileData struct {
    filePath string
    info     os.FileInfo
}

type hash [16]byte

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func checksum(filePath string) hash {
    bytes, err := ioutil.ReadFile(filePath)
    check(err)
    return hash(md5.Sum(bytes))
}

func findDuplicates(dirPath string, minSize int64) [][2]fileData {
    var dups [][2]fileData
    m := make(map[hash]fileData)
    werr := filepath.Walk(dirPath, func(path string, info os.FileInfo, err error) error {
        if err != nil {
            return err
        }
        if !info.IsDir() && info.Size() >= minSize {
            h := checksum(path)
            fd, ok := m[h]
            fd2 := fileData{path, info}
            if !ok {
                m[h] = fd2
            } else {
                dups = append(dups, [2]fileData{fd, fd2})
            }
        }
        return nil
    })
    check(werr)
    return dups
}

func main() {
    dups := findDuplicates(".", 1)
    fmt.Println("The following pairs of files have the same size and the same hash:\n")
    fmt.Println("File name                 Size      Date last modified")
    fmt.Println("==========================================================")
    sort.Slice(dups, func(i, j int) bool {
        return dups[i][0].info.Size() > dups[j][0].info.Size() // in order of decreasing size
    })
    for _, dup := range dups {
        for i := 0; i < 2; i++ {
            d := dup[i]
            fmt.Printf("%-20s  %8d    %v\n", d.filePath, d.info.Size(), d.info.ModTime().Format(time.ANSIC))
        }
        fmt.Println()
    }
}
