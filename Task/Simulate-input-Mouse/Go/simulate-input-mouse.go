package main

import "github.com/go-vgo/robotgo"

func main() {
    robotgo.MouseClick("left", false) // single clicks left mouse button
    robotgo.MouseClick("right", true) // double clicks right mouse button
}
