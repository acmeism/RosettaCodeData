package main

import (
    gl "github.com/chsc/gogl/gl21"
    "github.com/go-gl/glfw/v3.2/glfw"
    "log"
    "runtime"
)

// Window dimensions.
const (
    Width  = 640
    Height = 480
)

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    // OpenGL requires a dedicated OS thread.
    runtime.LockOSThread()
    defer runtime.UnlockOSThread()

    err := glfw.Init()
    check(err)
    defer glfw.Terminate()

    // Open window with the specified dimensions.
    window, err := glfw.CreateWindow(Width, Height, "Triangle", nil, nil)
    check(err)

    window.MakeContextCurrent()

    err = gl.Init()
    check(err) /* may need to comment out this line for this program to work on Windows 10 */

    // Initiate viewport.
    resize(Width, Height)

    // Register that we are interested in receiving close and resize events.
    window.SetCloseCallback(func(w *glfw.Window) {
        return
    })
    window.SetSizeCallback(func(w *glfw.Window, width, height int) {
        resize(width, height)
    })

    for !window.ShouldClose() {
        draw()
        window.SwapBuffers()
        glfw.PollEvents()
    }
}

// resize resizes the window to the specified dimensions.
func resize(width, height int) {
    gl.Viewport(0, 0, gl.Sizei(width), gl.Sizei(height))
    gl.MatrixMode(gl.PROJECTION)
    gl.LoadIdentity()
    gl.Ortho(-30.0, 30.0, -30.0, 30.0, -30.0, 30.0)
    gl.MatrixMode(gl.MODELVIEW)
}

// draw draws the triangle.
func draw() {
    gl.ClearColor(0.3, 0.3, 0.3, 0.0)
    gl.Clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)

    gl.ShadeModel(gl.SMOOTH)

    gl.LoadIdentity()
    gl.Translatef(-15.0, -15.0, 0.0)

    gl.Begin(gl.TRIANGLES)

    gl.Color3f(1.0, 0.0, 0.0)
    gl.Vertex2f(0.0, 0.0)

    gl.Color3f(0.0, 1.0, 0.0)
    gl.Vertex2f(30.0, 0.0)

    gl.Color3f(0.0, 0.0, 1.0)
    gl.Vertex2f(0.0, 30.0)

    gl.End()

    gl.Flush()
}
