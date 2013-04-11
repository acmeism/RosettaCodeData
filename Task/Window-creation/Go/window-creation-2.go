package main

import (
    "sdl"
    "fmt"
)

func main() {
    if sdl.Init(sdl.INIT_VIDEO) != 0 {
        fmt.Println(sdl.GetError())
        return
    }
    defer sdl.Quit()

    if sdl.SetVideoMode(200, 200, 32, 0) == nil {
        fmt.Println(sdl.GetError())
        return
    }

    for e := new(sdl.Event); e.Wait() && e.Type != sdl.QUIT; {
    }
}
