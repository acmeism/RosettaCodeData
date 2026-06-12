package main

import (
    "fmt"
    "log"
    "math/big"
    "strings"
)

const alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

var big0 = new(big.Int)
var big58 = big.NewInt(58)

func reverse(s string) string {
    r := []rune(s)
    for i, j := 0, len(r)-1; i < len(r)/2; i, j = i+1, j-1 {
        r[i], r[j] = r[j], r[i]
    }
    return string(r)
}

func convertToBase58(hash string, base int) (string, error) {
    var x, ok = new(big.Int).SetString(hash, base)
    if !ok {
        return "", fmt.Errorf("'%v' is not a valid integer in base '%d'", hash, base)
    }
    var sb strings.Builder
    var rem = new(big.Int)
    for x.Cmp(big0) == 1 {
        x.QuoRem(x, big58, rem)
        r := rem.Int64()
        sb.WriteByte(alphabet[r])
    }
    return reverse(sb.String()), nil
}

func main() {
    s := "25420294593250030202636073700053352635053786165627414518"
    b, err := convertToBase58(s, 10)
    if err != nil {
        log.Fatal(err)
    }
    fmt.Println(s, "->", b)
    hashes := [...]string{
        "0x61",
        "0x626262",
        "0x636363",
        "0x73696d706c792061206c6f6e6720737472696e67",
        "0x516b6fcd0f",
        "0xbf4f89001e670274dd",
        "0x572e4794",
        "0xecac89cad93923c02321",
        "0x10c8511e",
    }
    for _, hash := range hashes {
        b58, err := convertToBase58(hash, 0)
        if err != nil {
            log.Fatal(err)
        }
        fmt.Printf("%-56s -> %s\n", hash, b58)
    }
}
