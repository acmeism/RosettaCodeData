package main

import (
    "github.com/gotk3/gotk3/gtk"
    "log"
    "math/rand"
    "strconv"
    "time"
)

func validateInput(window *gtk.Window, str string) (int64, bool) {
    i, err := strconv.ParseInt(str, 10, 64)
    if err != nil {
        dialog := gtk.MessageDialogNew(
            window,
            gtk.DIALOG_MODAL,
            gtk.MESSAGE_ERROR,
            gtk.BUTTONS_OK,
            "Invalid value",
        )
        dialog.Run()
        dialog.Destroy()
        return 0, false
    }
    return i, true
}

func check(err error, msg string) {
    if err != nil {
        log.Fatal(msg, err)
    }
}

func main() {
    rand.Seed(time.Now().UnixNano())
    gtk.Init(nil)

    window, err := gtk.WindowNew(gtk.WINDOW_TOPLEVEL)
    check(err, "Unable to create window:")
    window.SetTitle("Rosetta Code")
    window.SetPosition(gtk.WIN_POS_CENTER)
    window.Connect("destroy", func() {
        gtk.MainQuit()
    })

    box, err := gtk.BoxNew(gtk.ORIENTATION_HORIZONTAL, 1)
    check(err, "Unable to create box:")
    box.SetBorderWidth(1)

    label, err := gtk.LabelNew("Value:")
    check(err, "Unable to create label:")

    entry, err := gtk.EntryNew()
    check(err, "Unable to create entry:")
    entry.SetText("0") // initialize to zero
    entry.Connect("activate", func() {
        // read and validate the entered value
        str, _ := entry.GetText()
        validateInput(window, str)
    })

    // button to increment
    ib, err := gtk.ButtonNewWithLabel("Increment")
    check(err, "Unable to create increment button:")
    ib.Connect("clicked", func() {
        // read and validate the entered value
        str, _ := entry.GetText()
        if i, ok := validateInput(window, str); ok {
            entry.SetText(strconv.FormatInt(i+1, 10))
        }
    })

    // button to put in a random value if confirmed
    rb, err := gtk.ButtonNewWithLabel("Random")
    check(err, "Unable to create random button:")
    rb.Connect("clicked", func() {
        dialog := gtk.MessageDialogNew(
            window,
            gtk.DIALOG_MODAL,
            gtk.MESSAGE_QUESTION,
            gtk.BUTTONS_YES_NO,
            "Set random value",
        )
        answer := dialog.Run()
        dialog.Destroy()
        if answer == gtk.RESPONSE_YES {
            entry.SetText(strconv.Itoa(rand.Intn(10000)))
        }
    })

    box.PackStart(label, false, false, 2)
    box.PackStart(entry, false, false, 2)
    box.PackStart(ib, false, false, 2)
    box.PackStart(rb, false, false, 2)
    window.Add(box)

    window.ShowAll()
    gtk.Main()
}
