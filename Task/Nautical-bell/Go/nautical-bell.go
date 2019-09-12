package main

import (
    "fmt"
    "strings"
    "time"
)

func main() {
    watches := []string{
        "First", "Middle", "Morning", "Forenoon",
        "Afternoon", "Dog", "First",
    }
    for {
        t := time.Now()
        h := t.Hour()
        m := t.Minute()
        s := t.Second()
        if (m == 0 || m == 30) && s == 0 {
            bell := 0
            if m == 30 {
                bell = 1
            }
            bells := (h*2 + bell) % 8
            watch := h/4 + 1
            if bells == 0 {
                bells = 8
                watch--
            }
            sound := strings.Repeat("\a", bells)
            pl := "s"
            if bells == 1 {
                pl = " "
            }
            w := watches[watch] + " watch"
            if watch == 5 {
                if bells < 5 {
                    w = "First " + w
                } else {
                    w = "Last " + w
                }
            }
            fmt.Printf("%s%02d:%02d = %d bell%s : %s\n", sound, h, m, bells, pl, w)
        }
        time.Sleep(1 * time.Second)
    }
}
