using Gtk.ShortNames

function keypresswindow()

    # This code creates  the Gtk widgets on the screen.
    txt = "Type Y or N"
    win = Window("Keypress Test", 250, 30) |> (Frame() |> ((vbox = Box(:v)) |> (lab = Label(txt))))

    # this is the keystroke processing code, a function and a callback for the function.
    function keycall(w, event)
        ch = Char(event.keyval)
        set_gtk_property!(lab,:label, ch in('n','N','y','Y') ? "You hit the $ch key." : txt)
    end
    Gtk.signal_connect(keycall, win, "key-press-event")

    # this code sets up a proper exit when the widow is closed.
    c = Condition()
    endit(w) = notify(c)
    Gtk.signal_connect(endit, win, :destroy)
    Gtk.showall(win)
    wait(c)
end

keypresswindow()
