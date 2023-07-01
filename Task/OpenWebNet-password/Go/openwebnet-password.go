package main

import (
    "fmt"
    "strconv"
)

func ownCalcPass(password, nonce string) uint32 {
    start := true
    num1 := uint32(0)
    num2 := num1
    i, _ := strconv.Atoi(password)
    pwd := uint32(i)
    for _, c := range nonce {
        if c != '0' {
            if start {
                num2 = pwd
            }
            start = false
        }
        switch c {
        case '1':
            num1 = (num2 & 0xFFFFFF80) >> 7
            num2 = num2 << 25
        case '2':
            num1 = (num2 & 0xFFFFFFF0) >> 4
            num2 = num2 << 28
        case '3':
            num1 = (num2 & 0xFFFFFFF8) >> 3
            num2 = num2 << 29
        case '4':
            num1 = num2 << 1
            num2 = num2 >> 31
        case '5':
            num1 = num2 << 5
            num2 = num2 >> 27
        case '6':
            num1 = num2 << 12
            num2 = num2 >> 20
        case '7':
            num3 := num2 & 0x0000FF00
            num4 := ((num2 & 0x000000FF) << 24) | ((num2 & 0x00FF0000) >> 16)
            num1 = num3 | num4
            num2 = (num2 & 0xFF000000) >> 8
        case '8':
            num1 = (num2&0x0000FFFF)<<16 | (num2 >> 24)
            num2 = (num2 & 0x00FF0000) >> 8
        case '9':
            num1 = ^num2
        default:
            num1 = num2
        }

        num1 &= 0xFFFFFFFF
        num2 &= 0xFFFFFFFF
        if c != '0' && c != '9' {
            num1 |= num2
        }
        num2 = num1
    }
    return num1
}

func testPasswordCalc(password, nonce string, expected uint32) {
    res := ownCalcPass(password, nonce)
    m := fmt.Sprintf("%s  %s  %-10d  %-10d", password, nonce, res, expected)
    if res == expected {
        fmt.Println("PASS", m)
    } else {
        fmt.Println("FAIL", m)
    }
}

func main() {
    testPasswordCalc("12345", "603356072", 25280520)
    testPasswordCalc("12345", "410501656", 119537670)
    testPasswordCalc("12345", "630292165", 4269684735)
}
