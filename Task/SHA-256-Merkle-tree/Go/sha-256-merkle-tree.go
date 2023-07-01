package main

import (
    "crypto/sha256"
    "fmt"
    "io"
    "log"
    "os"
)

func main() {
    const blockSize = 1024
    f, err := os.Open("title.png")
    if err != nil {
        log.Fatal(err)
    }
    defer f.Close()

    var hashes [][]byte
    buffer := make([]byte, blockSize)
    h := sha256.New()
    for {
        bytesRead, err := f.Read(buffer)
        if err != nil {
            if err != io.EOF {
                log.Fatal(err)
            }
            break
        }
        h.Reset()
        h.Write(buffer[:bytesRead])
        hashes = append(hashes, h.Sum(nil))
    }
    buffer = make([]byte, 64)
    for len(hashes) > 1 {
        var hashes2 [][]byte
        for i := 0; i < len(hashes); i += 2 {
            if i < len(hashes)-1 {
                copy(buffer, hashes[i])
                copy(buffer[32:], hashes[i+1])
                h.Reset()
                h.Write(buffer)
                hashes2 = append(hashes2, h.Sum(nil))
            } else {
                hashes2 = append(hashes2, hashes[i])
            }
        }
        hashes = hashes2
    }
    fmt.Printf("%x", hashes[0])
    fmt.Println()
}
