using Gtk

function flush_keyboard()
    win = GtkWindow("", 1, 1)
    keyget(w, event) = Int32(0)
    signal_connect(keyget, win, "key-press-event")
    visible(win, false)
    sleep(0.25)
end
