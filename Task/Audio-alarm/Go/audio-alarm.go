package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "os/exec"
    "strconv"
    "time"
)

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    number := 0
    for number < 1 {
        fmt.Print("Enter number of seconds delay > 0 : ")
        scanner.Scan()
        input := scanner.Text()
        if err := scanner.Err(); err != nil {
            log.Fatal(err)
        }
        number, _ = strconv.Atoi(input)
    }

    filename := ""
    for filename == "" {
        fmt.Print("Enter name of .mp3 file to play (without extension) : ")
        scanner.Scan()
        filename = scanner.Text()
        if err := scanner.Err(); err != nil {
            log.Fatal(err)
        }
    }

    cls := "\033[2J\033[0;0H" // ANSI escape code to clear screen and home cursor
    fmt.Printf("%sAlarm will sound in %d seconds...", cls, number)
    time.Sleep(time.Duration(number) * time.Second)
    fmt.Printf(cls)
    cmd := exec.Command("play", filename+".mp3")
    if err := cmd.Run(); err != nil {
        log.Fatal(err)
    }
}
