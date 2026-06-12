using Gtk

function set_gtk_style!(widget::Gtk.GtkWidget, style::String, value::Int)
    sc = Gtk.GAccessor.style_context(widget)
    pr = Gtk.CssProviderLeaf(data=" button {$style}")
    push!(sc, Gtk.StyleProvider(pr), value)
end

function squareonesapp(N)
    win = GtkWindow("Ones Square", 700, 700)
    grid = GtkGrid()
    buttons = [GtkButton(i == 1 || j == 1 || i == N || j == N ? " 1 " : " 0 ") for i in 1:N, j in 1:N]
    for i in 1:N, j in 1:N
        grid[i, j] = buttons[i, j]
        set_gtk_property!(buttons[i, j], :expand, true)
        c = i == 1 || j == 1 || i == N || j == N ? "red" : "navy"
        set_gtk_style!(buttons[i, j], " font-size: 32px; background-color: $c ; ", 600)
    end
    push!(win, grid)
    condition = Condition()
    endit(w) = notify(condition)
    signal_connect(endit, win, :destroy)
    showall(win)
    wait(condition)
end

squareonesapp(8)
