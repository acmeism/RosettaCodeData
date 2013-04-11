package main

import (
    "code.google.com/p/x-go-binding/ui/x11"
    "fmt"
    "image"
    "image/color"
    "image/draw"
    "log"
    "os"
    "time"
)

var randcol = genrandcol()

func genrandcol() <-chan color.Color {
    c := make(chan color.Color)

    go func() {
        for {
            select {
            case c <- image.Black:
            case c <- image.White:
            }
        }
    }()

    return c
}

func gennoise(screen draw.Image) {
    for y := 0; y < 240; y++ {
        for x := 0; x < 320; x++ {
            screen.Set(x, y, <-randcol)
        }
    }
}

func fps() chan<- bool {
    up := make(chan bool)

    go func() {
        var frames int64
        var lasttime time.Time
        var totaltime time.Duration

        for {
            <-up
            frames++
            now := time.Now()
            totaltime += now.Sub(lasttime)
            if totaltime > time.Second {
                fmt.Printf("FPS: %v\n", float64(frames)/totaltime.Seconds())
                frames = 0
                totaltime = 0
            }
            lasttime = now
        }
    }()

    return up
}

func main() {
    win, err := x11.NewWindow()
    if err != nil {
        fmt.Println(err)
        os.Exit(1)
    }
    defer win.Close()

    go func() {
        upfps := fps()
        screen := win.Screen()

        for {
            gennoise(screen)

            win.FlushImage()

            upfps <- true
        }
    }()

    for _ = range win.EventChan() {
    }
}
