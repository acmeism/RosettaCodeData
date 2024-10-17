using Gtk

const win = GtkWindow("Get Mouse Position", 600, 800)
const butn = GtkButton("Click Me Somewhere")
push!(win, butn)

callback(b, evt) = set_gtk_property!(win, :title, "Mouse Position: X is $(evt.x), Y is $(evt.y)")
signal_connect(callback, butn, "button-press-event")

showall(win)

c = Condition()
endit(w) = notify(c)
signal_connect(endit, win, :destroy)
wait(c)
