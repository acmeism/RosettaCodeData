package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
)

type SomeStruct struct {
    runtimeFields map[string]string
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    ss := SomeStruct{make(map[string]string)}
    scanner := bufio.NewScanner(os.Stdin)
    fmt.Println("Create two fields at runtime: ")
    for i := 1; i <= 2; i++ {
        fmt.Printf("  Field #%d:\n", i)
        fmt.Print("       Enter name  : ")
        scanner.Scan()
        name := scanner.Text()
        fmt.Print("       Enter value : ")
        scanner.Scan()
        value := scanner.Text()
        check(scanner.Err())
        ss.runtimeFields[name] = value
        fmt.Println()
    }
    for {
        fmt.Print("Which field do you want to inspect ? ")
        scanner.Scan()
        name := scanner.Text()
        check(scanner.Err())
        value, ok := ss.runtimeFields[name]
        if !ok {
            fmt.Println("There is no field of that name, try again")
        } else {
            fmt.Printf("Its value is '%s'\n", value)
            return
        }
    }
}
