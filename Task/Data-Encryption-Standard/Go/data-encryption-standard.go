package main

import (
    "crypto/des"
    "encoding/hex"
    "fmt"
    "log"
)

func main() {
    key, err := hex.DecodeString("0e329232ea6d0d73")
    if err != nil {
        log.Fatal(err)
    }
    c, err := des.NewCipher(key)
    if err != nil {
        log.Fatal(err)
    }
    src, err := hex.DecodeString("8787878787878787")
    if err != nil {
        log.Fatal(err)
    }
    dst := make([]byte, des.BlockSize)
    c.Encrypt(dst, src)
    fmt.Printf("%x\n", dst)
}
