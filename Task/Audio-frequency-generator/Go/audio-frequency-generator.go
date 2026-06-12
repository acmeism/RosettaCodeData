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
    freq := 0
    for freq < 40 || freq > 10000 {
        fmt.Print("Enter frequency in Hz (40 to 10000) : ")
        scanner.Scan()
        input := scanner.Text()
        check(scanner.Err())
        freq, _ = strconv.Atoi(input)
    }
    freqS := strconv.Itoa(freq)

    vol := 0
    for vol < 1 || vol > 50 {
        fmt.Print("Enter volume in dB (1 to 50) : ")
        scanner.Scan()
        input := scanner.Text()
        check(scanner.Err())
        vol, _ = strconv.Atoi(input)
    }
    volS := strconv.Itoa(vol)

    dur := 0.0
    for dur < 2 || dur > 10 {
        fmt.Print("Enter duration in seconds (2 to 10) : ")
        scanner.Scan()
        input := scanner.Text()
        check(scanner.Err())
        dur, _ = strconv.ParseFloat(input, 64)
    }
    durS := strconv.FormatFloat(dur, 'f', -1, 64)

    kind := 0
    for kind < 1 || kind > 3 {
        fmt.Print("Enter kind (1 = Sine, 2 = Square, 3 = Sawtooth) : ")
        scanner.Scan()
        input := scanner.Text()
        check(scanner.Err())
        kind, _ = strconv.Atoi(input)
    }
    kindS := "sine"
    if kind == 2 {
        kindS = "square"
    } else if kind == 3 {
        kindS = "sawtooth"
    }

    args := []string{"-n", "synth", durS, kindS, freqS, "vol", volS, "dB"}
    cmd := exec.Command("play", args...)
    err := cmd.Run()
    check(err)
}
