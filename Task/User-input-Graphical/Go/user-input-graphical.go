package main

import (
    "github.com/gotk3/gotk3/gtk"
    "log"
    "math/rand"
    "strconv"
    "time"
)

func validateInput(window *gtk.Window, str1, str2 string) bool {
    n, err := strconv.ParseFloat(str2, 64)
    if len(str1) == 0 || err != nil || n != 75000 {
        dialog := gtk.MessageDialogNew(
            window,
            gtk.DIALOG_MODAL,
            gtk.MESSAGE_ERROR,
            gtk.BUTTONS_OK,
            "Invalid input",
        )
        dialog.Run()
        dialog.Destroy()
        return false
    }
    return true
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

    vbox, err := gtk.BoxNew(gtk.ORIENTATION_VERTICAL, 1)
    check(err, "Unable to create vertical box:")
    vbox.SetBorderWidth(1)

    hbox1, err := gtk.BoxNew(gtk.ORIENTATION_HORIZONTAL, 1)
    check(err, "Unable to create first horizontal box:")

    hbox2, err := gtk.BoxNew(gtk.ORIENTATION_HORIZONTAL, 1)
    check(err, "Unable to create second horizontal box:")

    label, err := gtk.LabelNew("Enter a string and the number 75000   \n")
    check(err, "Unable to create label:")

    sel, err := gtk.LabelNew("String:      ")
    check(err, "Unable to create string entry label:")

    nel, err := gtk.LabelNew("Number: ")
    check(err, "Unable to create number entry label:")

    se, err := gtk.EntryNew()
    check(err, "Unable to create string entry:")

    ne, err := gtk.EntryNew()
    check(err, "Unable to create number entry:")

    hbox1.PackStart(sel, false, false, 2)
    hbox1.PackStart(se, false, false, 2)

    hbox2.PackStart(nel, false, false, 2)
    hbox2.PackStart(ne, false, false, 2)

    // button to accept
    ab, err := gtk.ButtonNewWithLabel("Accept")
    check(err, "Unable to create accept button:")
    ab.Connect("clicked", func() {
        // read and validate the entered values
        str1, _ := se.GetText()
        str2, _ := ne.GetText()
        if validateInput(window, str1, str2) {
            window.Destroy() // close window if input is OK
        }
    })

    vbox.Add(label)
    vbox.Add(hbox1)
    vbox.Add(hbox2)
    vbox.Add(ab)
    window.Add(vbox)

    window.ShowAll()
    gtk.Main()
}
