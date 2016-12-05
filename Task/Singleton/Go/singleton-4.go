package single

import (
    "log"
    "sync"
)

var (
    color string
    once  sync.Once
)

func Color() string {
    if color == "" {
        panic("color not initialized")
    }
    return color
}

func SetColor(c string) {
    log.Println("color initialization")
    once.Do(func() { color = c })
    log.Println("color initialized to", color)
}
