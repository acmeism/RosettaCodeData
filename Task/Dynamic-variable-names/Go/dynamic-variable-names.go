package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "strconv"
    "strings"
)

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    n := 0
    for n < 1 || n > 5 {
        fmt.Print("How many integer variables do you want to create (max 5) : ")
        scanner.Scan()
        n, _ = strconv.Atoi(scanner.Text())
        check(scanner.Err())
    }
    vars := make(map[string]int)
    fmt.Println("OK, enter the variable names and their values, below")
    for i := 1; i <= n; {
        fmt.Println("\n  Variable", i)
        fmt.Print("    Name  : ")
        scanner.Scan()
        name := scanner.Text()
        check(scanner.Err())
        if _, ok := vars[name]; ok {
            fmt.Println("  Sorry, you've already created a variable of that name, try again")
            continue
        }
        var value int
        var err error
        for {
            fmt.Print("    Value : ")
            scanner.Scan()
            value, err = strconv.Atoi(scanner.Text())
            check(scanner.Err())
            if err != nil {
                fmt.Println("  Not a valid integer, try again")
            } else {
                break
            }
        }
        vars[name] = value
        i++
    }
    fmt.Println("\nEnter q to quit")
    for {
        fmt.Print("\nWhich variable do you want to inspect : ")
        scanner.Scan()
        name := scanner.Text()
        check(scanner.Err())
        if s := strings.ToLower(name); s == "q" {
            return
        }
        v, ok := vars[name]
        if !ok {
            fmt.Println("Sorry there's no variable of that name, try again")
        } else {
            fmt.Println("It's value is", v)
        }
    }
}
