package main

import (
    "log"
    "time"

    "github.com/gdamore/tcell"
)

const (
    msg             = "Hello World! "
    x0, y0          = 8, 3
    shiftsPerSecond = 4
    clicksToExit    = 5
)

func main() {
    s, err := tcell.NewScreen()
    if err != nil {
        log.Fatal(err)
    }
    if err = s.Init(); err != nil {
        log.Fatal(err)
    }
    s.Clear()
    s.EnableMouse()
    tick := time.Tick(time.Second / shiftsPerSecond)
    click := make(chan bool)
    go func() {
        for {
            em, ok := s.PollEvent().(*tcell.EventMouse)
            if !ok || em.Buttons()&0xFF == tcell.ButtonNone {
                continue
            }
            mx, my := em.Position()
            if my == y0 && mx >= x0 && mx < x0+len(msg) {
                click <- true
            }
        }
    }()
    for inc, shift, clicks := 1, 0, 0; ; {
        select {
        case <-tick:
            shift = (shift + inc) % len(msg)
            for i, r := range msg {
                s.SetContent(x0+((shift+i)%len(msg)), y0, r, nil, 0)
            }
            s.Show()
        case <-click:
            clicks++
            if clicks == clicksToExit {
                s.Fini()
                return
            }
            inc = len(msg) - inc
        }
    }
}
