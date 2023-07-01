package main

import (
    "fmt"
    "log"
    "strings"
)

const digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

func reverse(bs []byte) []byte {
    for i, j := 0, len(bs)-1; i < len(bs)/2; i, j = i+1, j-1 {
        bs[i], bs[j] = bs[j], bs[i]
    }
    return bs
}

func encodeNegBase(n, b int64) (string, error) {
    if b < -62 || b > -1 {
        return "", fmt.Errorf("base must be between -62 and -1 inclusive")
    }
    if n == 0 {
        return "0", nil
    }
    var out []byte
    for n != 0 {
        rem := n % b
        n /= b
        if rem < 0 {
            n++
            rem -= b
        }
        out = append(out, digits[int(rem)])
    }
    reverse(out)
    return string(out), nil
}

func decodeNegBase(ns string, b int64) (int64, error) {
    if b < -62 || b > -1 {
        return 0, fmt.Errorf("base must be between -62 and -1 inclusive")
    }
    if ns == "0" {
        return 0, nil
    }
    total := int64(0)
    bb := int64(1)
    bs := []byte(ns)
    reverse(bs)
    for _, c := range bs {
        total += int64(strings.IndexByte(digits, c)) * bb
        bb *= b
    }
    return total, nil
}

func main() {
    numbers := []int64{10, 146, 15, -942, 1488588316238}
    bases := []int64{-2, -3, -10, -62, -62}
    for i := 0; i < len(numbers); i++ {
        n := numbers[i]
        b := bases[i]
        ns, err := encodeNegBase(n, b)
        if err != nil {
            log.Fatal(err)
        }
        fmt.Printf("%13d encoded in base %-3d = %s\n", n, b, ns)
        n, err = decodeNegBase(ns, b)
        if err != nil {
            log.Fatal(err)
        }
        fmt.Printf("%13s decoded in base %-3d = %d\n\n", ns, b, n)
    }
}
