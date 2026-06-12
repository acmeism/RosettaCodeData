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
    const sec = "00:00:01"
    scanner := bufio.NewScanner(os.Stdin)
    name := ""
    for name == "" {
        fmt.Print("Enter name of audio file to be trimmed : ")
        scanner.Scan()
        name = scanner.Text()
        check(scanner.Err())
    }

    name2 := ""
    for name2 == "" {
        fmt.Print("Enter name of output file              : ")
        scanner.Scan()
        name2 = scanner.Text()
        check(scanner.Err())
    }

    squelch := 0.0
    for squelch < 1 || squelch > 10 {
        fmt.Print("Enter squelch level % max (1 to 10)    : ")
        scanner.Scan()
        input := scanner.Text()
        check(scanner.Err())
        squelch, _ = strconv.ParseFloat(input, 64)
    }
    squelchS := strconv.FormatFloat(squelch, 'f', -1, 64) + "%"

    tmp1 := "tmp1_" + name
    tmp2 := "tmp2_" + name

    // Trim audio below squelch level from start and output to tmp1.
    args := []string{name, tmp1, "silence", "1", sec, squelchS}
    cmd := exec.Command("sox", args...)
    err := cmd.Run()
    check(err)

    // Reverse tmp1 to tmp2.
    args = []string{tmp1, tmp2, "reverse"}
    cmd = exec.Command("sox", args...)
    err = cmd.Run()
    check(err)

    // Trim audio below squelch level from tmp2 and output to tmp1.
    args = []string{tmp2, tmp1, "silence", "1", sec, squelchS}
    cmd  = exec.Command("sox", args...)
    err = cmd.Run()
    check(err)

    // Reverse tmp1 to the output file.
    args = []string{tmp1, name2, "reverse"}
    cmd = exec.Command("sox", args...)
    err = cmd.Run()
    check(err)

    // Remove the temporary files.
    err = os.Remove(tmp1)
    check(err)
    err = os.Remove(tmp2)
    check(err)
}
