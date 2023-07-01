package main

import (
    "fmt"
    "github.com/mattn/go-gtk/gtk"
)

func main() {
    gtk.Init(nil)
    window := gtk.NewWindow(gtk.WINDOW_TOPLEVEL)
    window.SetTitle("Click me")
    label := gtk.NewLabel("There have been no clicks yet")
    var clicks int
    button := gtk.NewButtonWithLabel("click me")
    button.Clicked(func() {
        clicks++
        if clicks == 1 {
            label.SetLabel("Button clicked 1 time")
        } else {
            label.SetLabel(fmt.Sprintf("Button clicked %d times",
                clicks))
        }
    })
    vbox := gtk.NewVBox(false, 1)
    vbox.Add(label)
    vbox.Add(button)
    window.Add(vbox)
    window.Connect("destroy", func() {
        gtk.MainQuit()
    })
    window.ShowAll()
    gtk.Main()
}
