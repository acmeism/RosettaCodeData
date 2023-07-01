package main

import (
    "fmt"
    "log"
    "os"
    "strconv"
    "strings"
)

const luckySize = 60000

var luckyOdd = make([]int, luckySize)
var luckyEven = make([]int, luckySize)

func init() {
    for i := 0; i < luckySize; i++ {
        luckyOdd[i] = i*2 + 1
        luckyEven[i] = i*2 + 2
    }
}

func filterLuckyOdd() {
    for n := 2; n < len(luckyOdd); n++ {
        m := luckyOdd[n-1]
        end := (len(luckyOdd)/m)*m - 1
        for j := end; j >= m-1; j -= m {
            copy(luckyOdd[j:], luckyOdd[j+1:])
            luckyOdd = luckyOdd[:len(luckyOdd)-1]
        }
    }
}

func filterLuckyEven() {
    for n := 2; n < len(luckyEven); n++ {
        m := luckyEven[n-1]
        end := (len(luckyEven)/m)*m - 1
        for j := end; j >= m-1; j -= m {
            copy(luckyEven[j:], luckyEven[j+1:])
            luckyEven = luckyEven[:len(luckyEven)-1]
        }
    }
}

func printSingle(j int, odd bool) error {
    if odd {
        if j >= len(luckyOdd) {
            return fmt.Errorf("the argument, %d, is too big", j)
        }
        fmt.Println("Lucky number", j, "=", luckyOdd[j-1])
    } else {
        if j >= len(luckyEven) {
            return fmt.Errorf("the argument, %d, is too big", j)
        }
        fmt.Println("Lucky even number", j, "=", luckyEven[j-1])
    }
    return nil
}

func printRange(j, k int, odd bool) error {
    if odd {
        if k >= len(luckyOdd) {
            return fmt.Errorf("the argument, %d, is too big", k)
        }
        fmt.Println("Lucky numbers", j, "to", k, "are:")
        fmt.Println(luckyOdd[j-1 : k])
    } else {
        if k >= len(luckyEven) {
            return fmt.Errorf("the argument, %d, is too big", k)
        }
        fmt.Println("Lucky even numbers", j, "to", k, "are:")
        fmt.Println(luckyEven[j-1 : k])
    }
    return nil
}

func printBetween(j, k int, odd bool) error {
    var r []int
    if odd {
        max := luckyOdd[len(luckyOdd)-1]
        if j > max || k > max {
            return fmt.Errorf("at least one argument, %d or %d, is too big", j, k)
        }
        for _, num := range luckyOdd {
            if num < j {
                continue
            }
            if num > k {
                break
            }
            r = append(r, num)
        }
        fmt.Println("Lucky numbers between", j, "and", k, "are:")
        fmt.Println(r)
    } else {
        max := luckyEven[len(luckyEven)-1]
        if j > max || k > max {
            return fmt.Errorf("at least one argument, %d or %d, is too big", j, k)
        }
        for _, num := range luckyEven {
            if num < j {
                continue
            }
            if num > k {
                break
            }
            r = append(r, num)
        }
        fmt.Println("Lucky even numbers between", j, "and", k, "are:")
        fmt.Println(r)
    }
    return nil
}

func main() {
    nargs := len(os.Args)
    if nargs < 2 || nargs > 4 {
        log.Fatal("there must be between 1 and 3 command line arguments")
    }
    filterLuckyOdd()
    filterLuckyEven()
    j, err := strconv.Atoi(os.Args[1])
    if err != nil || j < 1 {
        log.Fatalf("first argument, %s, must be a positive integer", os.Args[1])
    }
    if nargs == 2 {
        if err := printSingle(j, true); err != nil {
            log.Fatal(err)
        }
        return
    }

    if nargs == 3 {
        k, err := strconv.Atoi(os.Args[2])
        if err != nil {
            log.Fatalf("second argument, %s, must be an integer", os.Args[2])
        }
        if k >= 0 {
            if j > k {
                log.Fatalf("second argument, %d, can't be less than first, %d", k, j)
            }
            if err := printRange(j, k, true); err != nil {
                log.Fatal(err)
            }
        } else {
            l := -k
            if j > l {
                log.Fatalf("second argument, %d, can't be less in absolute value than first, %d", k, j)
            }
            if err := printBetween(j, l, true); err != nil {
                log.Fatal(err)
            }
        }
        return
    }

    var odd bool
    switch lucky := strings.ToLower(os.Args[3]); lucky {
    case "lucky":
        odd = true
    case "evenlucky":
        odd = false
    default:
        log.Fatalf("third argument, %s, is invalid", os.Args[3])
    }
    if os.Args[2] == "," {
        if err := printSingle(j, odd); err != nil {
            log.Fatal(err)
        }
        return
    }

    k, err := strconv.Atoi(os.Args[2])
    if err != nil {
        log.Fatal("second argument must be an integer or a comma")
    }
    if k >= 0 {
        if j > k {
            log.Fatalf("second argument, %d, can't be less than first, %d", k, j)
        }
        if err := printRange(j, k, odd); err != nil {
            log.Fatal(err)
        }
    } else {
        l := -k
        if j > l {
            log.Fatalf("second argument, %d, can't be less in absolute value than first, %d", k, j)
        }
        if err := printBetween(j, l, odd); err != nil {
            log.Fatal(err)
        }
    }
}
