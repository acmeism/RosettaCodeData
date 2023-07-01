using Gtk.ShortNames

function clickwindow()
    clicks = 0
    win = Window("Click Counter", 300, 100) |> (Frame() |> (vbox = Box(:v)))
    lab = Label("There have been no clicks yet.")
    but = Button("click me")
    push!(vbox, lab)
    push!(vbox, but)
    set_gtk_property!(vbox, :expand, lab, true)
    set_gtk_property!(vbox, :spacing, 20)
    callback(w) = (clicks += 1; set_gtk_property!(lab, :label, "There have been $clicks button clicks."))
    id = signal_connect(callback, but, :clicked)
    Gtk.showall(win)
    c = Condition()
    endit(w) = notify(c)
    signal_connect(endit, win, :destroy)
    wait(c)
end

clickwindow()
