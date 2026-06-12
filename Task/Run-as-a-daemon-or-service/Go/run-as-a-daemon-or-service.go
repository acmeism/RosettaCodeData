package main

import (
    "fmt"
    "github.com/sevlyar/go-daemon"
    "log"
    "os"
    "time"
)

func work() {
    f, err := os.Create("daemon_output.txt")
    if err != nil {
        log.Fatal(err)
    }
    defer f.Close()
    ticker := time.NewTicker(time.Second)
    go func() {
        for t := range ticker.C {
            fmt.Fprintln(f, t) // writes time to file every second
        }
    }()
    time.Sleep(60 * time.Second) // stops after 60 seconds at most
    ticker.Stop()
    log.Print("ticker stopped")
}

func main() {
    cntxt := &daemon.Context{
        PidFileName: "pid",
        PidFilePerm: 0644,
        LogFileName: "log",
        LogFilePerm: 0640,
        WorkDir:     "./",
        Umask:       027,
        Args:        []string{"[Rosetta Code daemon example]"},
    }

    d, err := cntxt.Reborn()
    if err != nil {
        log.Fatal("Unable to run: ", err)
    }
    if d != nil {
        return
    }
    defer cntxt.Release()

    log.Print("- - - - - - - - - - - - - - -")
    log.Print("daemon started")

    work()
}
