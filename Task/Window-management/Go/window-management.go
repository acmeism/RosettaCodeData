package main

import (
    "github.com/gotk3/gotk3/gtk"
    "log"
    "time"
)

func check(err error, msg string) {
    if err != nil {
        log.Fatal(msg, err)
    }
}

func main() {
    gtk.Init(nil)

    window, err := gtk.WindowNew(gtk.WINDOW_TOPLEVEL)
    check(err, "Unable to create window:")
    window.SetResizable(true)
    window.SetTitle("Window management")
    window.SetBorderWidth(5)
    window.Connect("destroy", func() {
        gtk.MainQuit()
    })

    stackbox, err := gtk.BoxNew(gtk.ORIENTATION_VERTICAL, 10)
    check(err, "Unable to create stack box:")

    bmax, err := gtk.ButtonNewWithLabel("Maximize")
    check(err, "Unable to create maximize button:")
    bmax.Connect("clicked", func() {
        window.Maximize()
    })

    bunmax, err := gtk.ButtonNewWithLabel("Unmaximize")
    check(err, "Unable to create unmaximize button:")
    bunmax.Connect("clicked", func() {
        window.Unmaximize()
    })

    bicon, err := gtk.ButtonNewWithLabel("Iconize")
    check(err, "Unable to create iconize button:")
    bicon.Connect("clicked", func() {
        window.Iconify()
    })

    bdeicon, err := gtk.ButtonNewWithLabel("Deiconize")
    check(err, "Unable to create deiconize button:")
    bdeicon.Connect("clicked", func() {
        window.Deiconify()
    })

    bhide, err := gtk.ButtonNewWithLabel("Hide")
    check(err, "Unable to create hide button:")
    bhide.Connect("clicked", func() {
        // not working on Ubuntu 16.04 but window 'dims' after a few seconds
        window.Hide()
        time.Sleep(10 * time.Second)
        window.Show()
    })

    bshow, err := gtk.ButtonNewWithLabel("Show")
    check(err, "Unable to create show button:")
    bshow.Connect("clicked", func() {
        window.Show()
    })

    bmove, err := gtk.ButtonNewWithLabel("Move")
    check(err, "Unable to create move button:")
    isShifted := false
    bmove.Connect("clicked", func() {
        w, h := window.GetSize()
        if isShifted {
            window.Move(w-10, h-10)
        } else {
            window.Move(w+10, h+10)
        }
        isShifted = !isShifted
    })

    bquit, err := gtk.ButtonNewWithLabel("Quit")
    check(err, "Unable to create quit button:")
    bquit.Connect("clicked", func() {
        window.Destroy()
    })

    stackbox.PackStart(bmax, true, true, 0)
    stackbox.PackStart(bunmax, true, true, 0)
    stackbox.PackStart(bicon, true, true, 0)
    stackbox.PackStart(bdeicon, true, true, 0)
    stackbox.PackStart(bhide, true, true, 0)
    stackbox.PackStart(bshow, true, true, 0)
    stackbox.PackStart(bmove, true, true, 0)
    stackbox.PackStart(bquit, true, true, 0)

    window.Add(stackbox)
    window.ShowAll()
    gtk.Main()
}
