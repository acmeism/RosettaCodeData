using Gtk.ShortNames


function clickwindow()
    clicks = 0
    win = Window("Click Counter", 300, 100) |> (Frame() |> (vbox = Box(:v)))
    lab = Label("There have been no clicks yet.")
    but = Button("click me")
    push!(vbox, lab)
    push!(vbox, but)
    setproperty!(vbox, :expand, lab, true)
    setproperty!(vbox, :spacing, 20)
    callback(w) = (clicks += 1; setproperty!(lab, :label, "There have been $clicks button clicks."))
    id = signal_connect(callback, but, "clicked")
    c = Condition()
    endit(w) = notify(c)
    signal_connect(endit, win, :destroy)
    showall(win)
    wait(c)
end


clickwindow()
