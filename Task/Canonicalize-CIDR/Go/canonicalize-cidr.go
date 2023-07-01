package main

import (
    "fmt"
    "log"
    "strconv"
    "strings"
)

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

// canonicalize a CIDR block: make sure none of the host bits are set
func canonicalize(cidr string) string {
    // dotted-decimal / bits in network part
    split := strings.Split(cidr, "/")
    dotted := split[0]
    size, err := strconv.Atoi(split[1])
    check(err)

    // get IP as binary string
    var bin []string
    for _, n := range strings.Split(dotted, ".") {
        i, err := strconv.Atoi(n)
        check(err)
        bin = append(bin, fmt.Sprintf("%08b", i))
    }
    binary := strings.Join(bin, "")

    // replace the host part with all zeros
    binary = binary[0:size] + strings.Repeat("0", 32-size)

    // convert back to dotted-decimal
    var canon []string
    for i := 0; i < len(binary); i += 8 {
        num, err := strconv.ParseInt(binary[i:i+8], 2, 64)
        check(err)
        canon = append(canon, fmt.Sprintf("%d", num))
    }

    // and return
    return strings.Join(canon, ".") + "/" + split[1]
}

func main() {
    tests := []string{
        "87.70.141.1/22",
        "36.18.154.103/12",
        "62.62.197.11/29",
        "67.137.119.181/4",
        "161.214.74.21/24",
        "184.232.176.184/18",
    }

    for _, test := range tests {
        fmt.Printf("%-18s -> %s\n", test, canonicalize(test))
    }
}
