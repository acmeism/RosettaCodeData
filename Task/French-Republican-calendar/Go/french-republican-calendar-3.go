package main

import (
    "bufio"
    "fmt"
    "os"
    "time"

    "frc"
)

func main() {
    fmt.Println("*** French  Republican ***")
    fmt.Println("*** calendar converter ***")
    fmt.Println("Enter a date to convert, in the format 'day month year'")
    fmt.Println("e.g.: 1 Prairial 3,")
    fmt.Println("      20 May 1795.")
    fmt.Println("For Sansculottides, use 'day year'")
    fmt.Println("e.g.: Fete de l'opinion 9.")
    fmt.Println("Or just press 'RETURN' to exit the program.")
    fmt.Println()
    for sc := bufio.NewScanner(os.Stdin); ; {
        fmt.Print("> ")
        sc.Scan()
        src := sc.Text()
        if src == "" {
            return
        }
        f, ok := frc.Parse(src)
        if ok {
            fmt.Println(f.ToGregorian())
            continue
        }
        t, err := time.Parse(`2 January 2006`, src)
        if err == nil {
            fmt.Println(frc.FromGregorian(t.Date()))
        }
    }
}
