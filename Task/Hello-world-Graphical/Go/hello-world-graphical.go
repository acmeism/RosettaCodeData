package main

import "github.com/mattn/go-gtk/gtk"

func main() {
   gtk.Init(nil)
   win := gtk.NewWindow(gtk.WINDOW_TOPLEVEL)
   win.SetTitle("Goodbye, World!")
   win.SetSizeRequest(300, 200)
   win.Connect("destroy", gtk.MainQuit)
   button := gtk.NewButtonWithLabel("Goodbye, World!")
   win.Add(button)
   button.Connect("clicked", gtk.MainQuit)
   win.ShowAll()
   gtk.Main()
}
