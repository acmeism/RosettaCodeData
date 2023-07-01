package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "os/exec"
    "strconv"
)

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    name := ""
    for name == "" {
        fmt.Print("Enter output file name (without extension) : ")
        scanner.Scan()
        name = scanner.Text()
        check(scanner.Err())
    }
    name += ".wav"

    rate := 0
    for rate < 2000 || rate > 192000 {
        fmt.Print("Enter sampling rate in Hz (2000 to 192000) : ")
        scanner.Scan()
        input := scanner.Text()
        check(scanner.Err())
        rate, _ = strconv.Atoi(input)
    }
    rateS := strconv.Itoa(rate)

    dur := 0.0
    for dur < 5 || dur > 30 {
        fmt.Print("Enter duration in seconds (5 to 30)        : ")
        scanner.Scan()
        input := scanner.Text()
        check(scanner.Err())
        dur, _ = strconv.ParseFloat(input, 64)
    }
    durS := strconv.FormatFloat(dur, 'f', -1, 64)

    fmt.Println("OK, start speaking now...")
    // Default arguments: -c 1, -t wav. Note only signed 16 bit format supported.
    args := []string{"-r", rateS, "-f", "S16_LE", "-d", durS, name}
    cmd := exec.Command("arecord", args...)
    err := cmd.Run()
    check(err)

    fmt.Printf("'%s' created on disk and will now be played back...\n", name)
    cmd = exec.Command("aplay", name)
    err = cmd.Run()
    check(err)
    fmt.Println("Play-back completed.")
}
