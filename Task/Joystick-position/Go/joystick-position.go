package main

import (
    "fmt"
    "github.com/nsf/termbox-go"
    "github.com/simulatedsimian/joystick"
    "log"
    "os"
    "strconv"
    "time"
)

func printAt(x, y int, s string) {
    for _, r := range s {
        termbox.SetCell(x, y, r, termbox.ColorDefault, termbox.ColorDefault)
        x++
    }
}

func readJoystick(js joystick.Joystick, hidden bool) {
    jinfo, err := js.Read()
    check(err)

    w, h := termbox.Size()
    tbcd := termbox.ColorDefault
    termbox.Clear(tbcd, tbcd)
    printAt(1, h-1, "q - quit")
    if hidden {
        printAt(11, h-1, "s - show buttons:")
    } else {
        bs := ""
        printAt(11, h-1, "h - hide buttons:")
        for button := 0; button < js.ButtonCount(); button++ {
            if jinfo.Buttons&(1<<uint32(button)) != 0 {
                // Buttons assumed to be numbered from 1, not 0.
                bs += fmt.Sprintf(" %X", button+1)
            }
        }
        printAt(28, h-1, bs)
    }

    // Map axis values in range -32767 to +32768 to termbox co-ordinates.
    x := int(float64((jinfo.AxisData[0]+32767)*(w-1)) / 65535)
    y := int(float64((jinfo.AxisData[1]+32767)*(h-2)) / 65535)
    printAt(x, y, "+") // display crosshair
    termbox.Flush()
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    // Under Linux the id is used to construct the joystick device name.
    // For example: id 0 will open device: "/dev/input/js0"
    // Under Windows the id is the actual numeric id of the joystick.
    jsid := 0
    // Optionally pass joystick id to be used as a command line argument.
    if len(os.Args) > 1 {
        i, err := strconv.Atoi(os.Args[1])
        check(err)
        jsid = i
    }

    js, jserr := joystick.Open(jsid)
    check(jserr)

    err := termbox.Init()
    check(err)
    defer termbox.Close()

    eventQueue := make(chan termbox.Event)
    go func() {
        for {
            eventQueue <- termbox.PollEvent()
        }
    }()

    ticker := time.NewTicker(time.Millisecond * 40)
    hidden := false // Controls whether button display hidden or not.

    for doQuit := false; !doQuit; {
        select {
        case ev := <-eventQueue:
            if ev.Type == termbox.EventKey {
                if ev.Ch == 'q' {
                    doQuit = true
                } else if ev.Ch == 'h' {
                    hidden = true
                } else if ev.Ch == 's' {
                    hidden = false
                }
            }
            if ev.Type == termbox.EventResize {
                termbox.Flush()
            }
        case <-ticker.C:
            readJoystick(js, hidden)
        }
    }
}
