package main

import (
    "github.com/mattn/go-gtk/glib"
    "github.com/mattn/go-gtk/gtk"
)

func main() {
    gtk.Init(nil)
    window := gtk.NewWindow(gtk.WINDOW_TOPLEVEL)
    window.Connect("destroy",
        func(*glib.CallbackContext) { gtk.MainQuit() }, "")
    window.Show()
    gtk.Main()
}
