using Gtk

function keypresswindow()
    tcount = 0
    txt = "Press a Key"
    win = GtkWindow("Keypress Test", 500, 30) |> (GtkFrame() |> ((vbox = GtkBox(:v)) |> (lab = GtkLabel(txt))))
    function keycall(w, event)
        ch = Char(event.keyval)
        tcount += 1
        set_gtk_property!(lab, :label, "You have typed $tcount chars including $ch this time")
    end
    signal_connect(keycall, win, "key-press-event")

    cond = Condition()
    endit(w) = notify(cond)
    signal_connect(endit, win, :destroy)
    showall(win)
    wait(cond)
end

keypresswindow()
