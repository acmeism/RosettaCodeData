package main

import (
    "crypto/ecdsa"
    "crypto/elliptic"
    "crypto/rand"
    "crypto/sha256"
    "encoding/binary"
    "fmt"
    "log"
)

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    priv, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
    check(err)
    fmt.Println("Private key:\nD:", priv.D)
    pub := priv.Public().(*ecdsa.PublicKey)
    fmt.Println("\nPublic key:")
    fmt.Println("X:", pub.X)
    fmt.Println("Y:", pub.Y)

    msg := "Rosetta Code"
    fmt.Println("\nMessage:", msg)
    hash := sha256.Sum256([]byte(msg)) // as [32]byte
    hexHash := fmt.Sprintf("0x%x", binary.BigEndian.Uint32(hash[:]))
    fmt.Println("Hash   :", hexHash)

    r, s, err := ecdsa.Sign(rand.Reader, priv, hash[:])
    check(err)
    fmt.Println("\nSignature:")
    fmt.Println("R:", r)
    fmt.Println("S:", s)

    valid := ecdsa.Verify(&priv.PublicKey, hash[:], r, s)
    fmt.Println("\nSignature verified:", valid)
}
