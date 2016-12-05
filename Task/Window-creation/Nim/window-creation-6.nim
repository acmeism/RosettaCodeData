import iup

# assumes you have the iup  .dll or .so installed

discard iup.open(nil,nil)


# now use a Dialog box to show a message
var lbl = label("Hello World")
setAttribute(lbl,"PADDING","10x10")

var contents = hbox(lbl, nil)
#SetAttribute(contents, "MARGIN", "5x5")

var dlg = dialog(contents)
#SetAttribute(dlg, "SIZE", "100x50")

discard dlg.show()

# a window via a quick message box, sitting on top of the main dialog window
discard Alarm("MyTitle","Hello World","Ok", "Not Ok", nil)

discard mainloop()
iup.close()
