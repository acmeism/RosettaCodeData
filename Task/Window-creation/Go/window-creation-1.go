package main

import "gtk"

func main() {
    gtk.Init(nil)
    window := gtk.Window(gtk.GTK_WINDOW_TOPLEVEL)
    window.Connect("destroy", func(*gtk.CallbackContext) {
        gtk.MainQuit()
    },
        "")
    window.Show()
    gtk.Main()
}
