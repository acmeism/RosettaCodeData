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

func processState(i int64, entry *gtk.Entry, ib, db *gtk.Button) {
    if i == 0 {
        entry.SetSensitive(true)
    } else {
        entry.SetSensitive(false)
    }
    if i < 10 {
        ib.SetSensitive(true)
    } else {
        ib.SetSensitive(false)
    }
    if i > 0 {
        db.SetSensitive(true)
    } else {
        db.SetSensitive(false)
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
    entry.SetSensitive(true)

    // button to increment
    ib, err := gtk.ButtonNewWithLabel("Increment")
    check(err, "Unable to create increment button:")
    ib.SetSensitive(true)

    // button to decrement
    db, err := gtk.ButtonNewWithLabel("Decrement")
    check(err, "Unable to create decrement button:")
    db.SetSensitive(false)

    entry.Connect("activate", func() {
        // read and validate the entered value
        str, _ := entry.GetText()
        i, ok := validateInput(window, str)
        if !ok {
            entry.SetText("0")
        }
        processState(i, entry, ib, db)
    })

    ib.Connect("clicked", func() {
        // read the entered value
        str, _ := entry.GetText()
        i, _ := validateInput(window, str)
        i++
        entry.SetText(strconv.FormatInt(i, 10))
        processState(i, entry, ib, db)
    })

    db.Connect("clicked", func() {
        // read the entered value
        str, _ := entry.GetText()
        i, _ := validateInput(window, str)
        i--
        entry.SetText(strconv.FormatInt(i, 10))
        processState(i, entry, ib, db)
    })

    box.PackStart(label, false, false, 2)
    box.PackStart(entry, false, false, 2)
    box.PackStart(ib, false, false, 2)
    box.PackStart(db, false, false, 2)
    window.Add(box)

    window.ShowAll()
    gtk.Main()
}
