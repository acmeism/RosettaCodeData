package main

import (
    "log"

    "github.com/veandco/go-sdl2/sdl"
)

func main() {
    window, err := sdl.CreateWindow("RC Window Creation",
        sdl.WINDOWPOS_UNDEFINED, sdl.WINDOWPOS_UNDEFINED,
        320, 200, 0)
    if err != nil {
        log.Fatal(err)
    }
    for {
        if _, ok := sdl.WaitEvent().(*sdl.QuitEvent); ok {
            break
        }
    }
    window.Destroy()
}
