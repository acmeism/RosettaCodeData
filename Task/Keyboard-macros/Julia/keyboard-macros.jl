using Gtk

function keypresswindow()
    tcount = 0
    txt = "Press a Number Key"
    win = GtkWindow("Keyboard Macros Test", 300, 50) |> (GtkFrame() |> ((vbox = GtkBox(:v)) |> (lab = GtkLabel(txt))))
    function keycall(w, event)
        ch = Char(event.keyval)
        if isdigit(ch)
            set_gtk_property!(lab, :label, "Keyboard Macro Number $ch Invoked.")
        end
    end
    signal_connect(keycall, win, "key-press-event")

    cond = Condition()
    endit(w) = notify(cond)
    signal_connect(endit, win, :destroy)
    showall(win)
    wait(cond)
end

keypresswindow()
