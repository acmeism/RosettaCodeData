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
    fileName := "loop.wav"
    scanner := bufio.NewScanner(os.Stdin)
    reps := 0
    for reps < 1 || reps > 6 {
        fmt.Print("Enter number of repetitions (1 to 6) : ")
        scanner.Scan()
        input := scanner.Text()
        check(scanner.Err())
        reps, _ = strconv.Atoi(input)
    }

    delay := 0
    for delay < 50 || delay > 500 {
        fmt.Print("Enter delay between repetitions in microseconds (50 to 500) : ")
        scanner.Scan()
        input := scanner.Text()
        check(scanner.Err())
        delay, _ = strconv.Atoi(input)
    }

    decay := 0.0
    for decay < 0.2 || decay > 0.9 {
        fmt.Print("Enter decay between repetitions (0.2 to 0.9) : ")
        scanner.Scan()
        input := scanner.Text()
        check(scanner.Err())
        decay, _ = strconv.ParseFloat(input, 64)
    }

    args := []string{fileName, "echo", "0.8", "0.7"}
    decay2 := 1.0
    for i := 1; i <= reps; i++ {
        delayStr := strconv.Itoa(i * delay)
        decay2 *= decay
        decayStr := strconv.FormatFloat(decay2, 'f', -1, 64)
        args = append(args, delayStr, decayStr)
    }
    cmd := exec.Command("play", args...)
    err := cmd.Run()
    check(err)
}
