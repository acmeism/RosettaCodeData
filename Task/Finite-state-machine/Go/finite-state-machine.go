package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "strings"
)

type state int

const (
    ready state = iota
    waiting
    exit
    dispense
    refunding
)

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func fsm() {
    fmt.Println("Please enter your option when prompted")
    fmt.Println("(any characters after the first will be ignored)")
    state := ready
    var trans string
    scanner := bufio.NewScanner(os.Stdin)
    for {
        switch state {
        case ready:
            for {
                fmt.Print("\n(D)ispense or (Q)uit : ")
                scanner.Scan()
                trans = scanner.Text()
                check(scanner.Err())
                if len(trans) == 0 {
                    continue
                }
                option := strings.ToLower(trans)[0]
                if option == 'd' {
                    state = waiting
                    break
                } else if option == 'q' {
                    state = exit
                    break
                }
            }
        case waiting:
            fmt.Println("OK, put your money in the slot")
            for {
                fmt.Print("(S)elect product or choose a (R)efund : ")
                scanner.Scan()
                trans = scanner.Text()
                check(scanner.Err())
                if len(trans) == 0 {
                    continue
                }
                option := strings.ToLower(trans)[0]
                if option == 's' {
                    state = dispense
                    break
                } else if option == 'r' {
                    state = refunding
                    break
                }
            }
        case dispense:
            for {
                fmt.Print("(R)emove product : ")
                scanner.Scan()
                trans = scanner.Text()
                check(scanner.Err())
                if len(trans) == 0 {
                    continue
                }
                option := strings.ToLower(trans)[0]
                if option == 'r' {
                    state = ready
                    break
                }
            }
        case refunding:
            // no transitions defined
            fmt.Println("OK, refunding your money")
            state = ready
        case exit:
            fmt.Println("OK, quitting")
            return
        }
    }
}

func main() {
    fsm()
}
